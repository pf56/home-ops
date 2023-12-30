{ pkgs, lib, ... }: #writeTextDir, writeShellScriptBin, symlinkJoin, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  eww = "${pkgs.eww-wayland}/bin/eww";
  jq = "${pkgs.jq}/bin/jq";
  hyprland-workspaces = "${pkgs.hyprland-workspaces}/bin/hyprland-workspaces";

  createEwwConfig = pkgs.writeShellScriptBin "create-eww-config"
    ''
      set -euo pipefail

      CONFIG_DIR=~/.config/eww-config
      mkdir -p $CONFIG_DIR
      
      MAIN_MONITOR=$(${getMainMonitor}/bin/get-main-monitor)
      MONITORS=$(${getMonitors}/bin/get-monitors)

      cat <<EOF > $CONFIG_DIR/eww.yuck
      ; THIS FILE IS GENERATED BY A SCRIPT
                  
      (defpoll DATETIME :interval "1s" \`date "+%Y-%m-%d %H:%M:%S"\`)
      ;(deflisten workspace "${hyprland-workspaces} _")
      (deflisten workspace0 "${hyprland-workspaces} $(echo $MONITORS | ${jq} -r '.[0].name')")
      (deflisten workspace1 "${hyprland-workspaces} $(echo $MONITORS | ${jq} -r '.[1].name')")
      (deflisten workspace2 "${hyprland-workspaces} $(echo $MONITORS | ${jq} -r '.[2].name')")

      (defwidget workspaces0 []
        (eventbox :onscroll "${hyprctl} dispatch workspace \`echo {} | sed 's/up/+/' | sed 's/down/-/'\`1"
          (box :class "workspaces"
            (for i in workspace0
              (button
                :onclick "${hyprctl} dispatch workspace \''${i.id}"
                :class "\''${i.class}"
                "\''${i.name}")))))

      (defwidget workspaces1 []
        (eventbox :onscroll "${hyprctl} dispatch workspace \`echo {} | sed 's/up/+/' | sed 's/down/-/'\`1"
          (box :class "workspaces"
            (for i in workspace1
              (button
                :onclick "${hyprctl} dispatch workspace \''${i.id}"
                :class "\''${i.class}"
                "\''${i.name}")))))

      (defwidget workspaces2 []
        (eventbox :onscroll "${hyprctl} dispatch workspace \`echo {} | sed 's/up/+/' | sed 's/down/-/'\`1"
          (box :class "workspaces"
            (for i in workspace2
              (button
                :onclick "${hyprctl} dispatch workspace \''${i.id}"
                :class "\''${i.class}"
                "\''${i.name}")))))

      (defwidget datetime []
        (box :class "datetime"
          (label :text DATETIME)))

      (defwindow bar0
            :monitor $(echo $MONITORS | ${jq} -r '.[0].index // 0')
            :geometry (geometry :x "0px"
                                :y "0px"
                                :width "100%"
                                :height "30px"
                                :anchor "top center")
            :stacking "fg"
            :exclusive true
            :namespace "eww"
        (box :class "main-container"
          (box :halign "start"
            (workspaces0))

          (box :halign "end"
            (datetime)))
        )
        
      (defwindow bar1
            :monitor $(echo $MONITORS | ${jq} -r '.[1].index // 0')
            :geometry (geometry :x "0px"
                                :y "0px"
                                :width "100%"
                                :height "30px"
                                :anchor "top center")
            :stacking "fg"
            :exclusive true
            :namespace "eww"
        (box :class "main-container"
          (box :halign "start"
            (workspaces1))

          (box :halign "end"
            (datetime)))
        )
        
      (defwindow bar2
            :monitor $(echo $MONITORS | ${jq} -r '.[2].index // 0')
            :geometry (geometry :x "0px"
                                :y "0px"
                                :width "100%"
                                :height "30px"
                                :anchor "top center")
            :stacking "fg"
            :exclusive true
            :namespace "eww"
        (box :class "main-container"
          (box :halign "start"
            (workspaces2))

          (box :halign "end"
            (datetime)))
        )
      EOF

      echo $CONFIG_DIR
      exit 0
    '';

  ewwScss = pkgs.writeTextDir "eww.scss"
    ''
      .workspace-active { color: blue; }
    '';

  getMainMonitor = pkgs.writeShellScriptBin "get-main-monitor"
    ''
      set -euo pipefail
      
      MAIN_MONITOR="912NTDV0N042"
      INTERNAL_DISPLAY="eDP-1"
      ${hyprctl} monitors -j | ${jq} -r \
        --arg SERIALNO $MAIN_MONITOR \
        --arg FALLBACK $INTERNAL_DISPLAY \
        'map(select(.serial == $SERIALNO))[0] // map(select(.name == $FALLBACK))[0] // {id: 0, name: "_"}'
    '';

  getMonitors = pkgs.writeShellScriptBin "get-monitors"
    ''
      set -euo pipefail
      
      MAIN_MONITOR="912NTDV0N042"
      INTERNAL_DISPLAY="eDP-1"

      # tries to sort the list of monitors in a way that MAIN_MONITOR or FALLBACK are the first items in the list
      ${hyprctl} monitors -j | ${jq} -r \
        --arg SERIALNO $MAIN_MONITOR \
        --arg FALLBACK $INTERNAL_DISPLAY \
        'to_entries | map((.value += {"index": .key}) | .value) | [(map(select(.serial == $SERIALNO))[0] // map(select(.name == $FALLBACK))[0])] + . | map({key: (.id | tostring), value: .}) | from_entries | map({id: .id, name: .name, index: .index}) | map(select(.id != null))'
    '';

  launchBars = pkgs.writeShellScriptBin "launch-bars"
    ''
      set -euo pipefail

      CONFIG_DIR=$(${createEwwConfig}/bin/create-eww-config)
      
      if [[ ! $(pidof eww) ]]; then
        ${eww} -c $CONFIG_DIR daemon
        sleep 1
      fi

      NB_MONITORS=($(${hyprctl} monitors -j | ${jq} -r '.[] | .id'))
      for i in "''${!NB_MONITORS[@]}"; do
        ${eww} -c $CONFIG_DIR open bar$i
      #  [[ $i == 0 ]] && ${eww} open-many sidebar notifications
      done
    '';
in
{
  home.packages = [ launchBars ];
}
#symlinkJoin {
#  name = "eww-config";
#  paths = [
#    createEwwConfig
#    ewwScss
#    launchBars
#    getMainMonitor
#  ];
#}
