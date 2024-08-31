#!/bin/bash

steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/dontstarvetogether_dedicated_server"
map_dir=$HOME/.klei/DoNotStarveTogether
mods_dir=$HOME/dontstarvetogether_dedicated_server/mods

print_menu() {
	if [[ $first_run != 'true' ]]; then
		sleep 1
	fi
	first_run=''

	printf $"
----------
version 1.0.6
服务器状态："
	if get_server_status; then
		printf "\\033[0;32m运行中\\033[0m\n"
	else
		printf "\\033[0;35m已停止\\033[0m\n"
	fi
	cmap=$(get_current_map)

	printf $"当前存档：%s
----------
1) 重启服务器
2) 停止服务器
3) 更新模组列表
4) 选择存档
5) 更新游戏
q) 退出
----------
" "$cmap"

	read -r inp
	case $inp in
	1)
		stop_server
		# update_game
		update_mods
		start_server
		update_ports
		;;
	2)
		stop_server
		;;
	3)
		update_mods
		;;
	4)
		select_map
		;;
	5)
		update_game
		;;
	q*)
		echo -e "\033[0;34mBye~\033[0m"
		exit 0
		;;
	*) ;;
	esac
	print_menu
}

update_mods() {
	mod_ids=()
	for f in "$map_dir"/"$cmap"/*/modoverrides.lua; do
		mod_ids+=($(sed -n 's#.*\"workshop-\([0-9]\+\)\".*#\1#p' "$f"))
	done

	awk '/^\s?--/ {print}' "$mods_dir"/dedicated_server_mods_setup.lua >"$mods_dir"/.dedicated_server_mods_setup.lua.new
	# ServerModSetup("350811795")
	# shellcheck disable=SC2068
	for id_ in $(echo ${mod_ids[@]} | tr ' ' '\n' | sort -nu); do
		if [[ ${#id_} -ge 15 ]]; then
			continue
		fi
		printf 'ServerModSetup("%s")\n' "$id_" >>"$mods_dir"/.dedicated_server_mods_setup.lua.new
	done

	cp -f "$mods_dir"/dedicated_server_mods_setup.lua "$mods_dir"/.dedicated_server_mods_setup.lua.bak
	mv "$mods_dir"/.dedicated_server_mods_setup.lua.new "$mods_dir"/dedicated_server_mods_setup.lua
	chmod +x "$mods_dir"/dedicated_server_mods_setup.lua
	echo -e "\033[0;32m模组已更新\033[0m"
}

update_ports() {
	printf "请开放端口：\033[0;32m"
	for p in $(grep -Eo 'port.+([0-9]+)' "$map_dir"/"$cmap"/*.ini "$map_dir"/"$cmap"/*/*.ini | sed -n 's|.*[^0-9]\([0-9]\+\)$|\1|p' | sort -nu); do
		printf '%d,' "$p"
	done
	printf '\b \033[0m\n'
}

get_server_status() {
	if ! pgrep dontstarve_dedi &>/dev/null; then
		return 1
	else
		return 0
	fi
}

tmux_kill_dedicated() {
	if tmux has-session -t dedicated &>/dev/null; then
		tmux kill-session -C t dedicated
		sleep 1
	fi
}

start_server() {
	if ! get_server_status; then
		tmux_kill_dedicated
		tmux new-session -d -s dedicated -c sh "$HOME/run_dedicated_servers.sh > >(tee /tmp/dedicated_servers.log)"
		for _ in {1..36}; do
			sleep 5
			echo -e "\033[0;34m服务器启动中\033[0m"
			if get_server_status; then
				grep -E 'Loading mod:|Sim paused' /tmp/dedicated_servers.log
				sleep 5
				break
			fi
		done
	fi
	echo -e "\033[0;32m服务器已启动\033[0m"
}

stop_server() {
	if get_server_status; then
		echo -e "\033[0;32m正在停止服务器\033[0m"
		for _ in {1..10}; do
			pkill --signal SIGINT dontstarve_dedi
		done
		sleep 3
	fi
	tmux_kill_dedicated
	if ! get_server_status; then
		echo -e "\033[0;32m服务器已停止\033[0m"
	else
		echo -e "\033[0;31m服务器停止失败\033[0m"
	fi
}

select_map() {
	mapfile -t maps < <(ls "$map_dir")
	idx=0
	for m in "${maps[@]}"; do
		idx=$((idx + 1))
		printf '%2d) %s\n' "$idx" "$m"
	done
	read -r inp
	if [[ $inp -gt 0 && $inp -le $idx ]]; then
		sed -i "s|cluster_name.*=.*\"\\(.*\\)\"|cluster_name=\"${maps[$((inp - 1))]}\"|" "$HOME"/run_dedicated_servers.sh
		printf "\033[0;32m选择：%s\033[0m\n" "${maps[$((inp - 1))]}"
	else
		printf "\033[0;31m选择错误\033[0m\n"
	fi
}

get_current_map() {
	sed -n 's|cluster_name.*=.*"\(.*\)"|\1|p' "$HOME"/run_dedicated_servers.sh
}

update_game() {
	if [[ ! -d "$steamcmd_dir" ]]; then
		printf "\033[0;31mMissing %s directory!\033[0m\n" "$steamcmd_dir"
		exit 1
	fi
	cd "$steamcmd_dir" || exit
	./steamcmd.sh +force_install_dir "$install_dir" +login anonymous +app_update 343050 validate +quit
	printf "\033[0;32m游戏更新完成\033[0m"
}

first_run='true'
cmap=''
print_menu

# vim: set ts=2 sw=2 noet:
