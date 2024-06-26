{ config, pkgs, lib, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  eww = "${pkgs.eww}/bin/eww";
  jq = "${pkgs.jq}/bin/jq";
  hyprland-workspaces = "${pkgs.hyprland-workspaces}/bin/hyprland-workspaces";
  yubikey-touch-detector = pkgs.callPackage ./scripts/yubikey-touch-detector { };

  createEwwConfig = pkgs.writeShellScriptBin "create-eww-config"
    ''
      set -euo pipefail

      CONFIG_DIR=~/.config/eww-config
      mkdir -p $CONFIG_DIR
      
      MONITORS=$(${getMonitors}/bin/get-monitors)

      cat <<EOF > $CONFIG_DIR/eww.yuck
      ; THIS FILE IS GENERATED BY A SCRIPT

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

      (defpoll DATETIME :interval "1s" \`date "+%Y-%m-%d %H:%M:%S"\`)
      (defwidget datetime []
        (box :class "datetime"
          (label :text DATETIME)))

      (deflisten YUBIKEY_TOUCH_DETECTOR \`${yubikey-touch-detector}/bin/main.py\`)
      (defwidget yubikey-touch-detector []
        (box :class {YUBIKEY_TOUCH_DETECTOR.class}
          (label :text {YUBIKEY_TOUCH_DETECTOR.text})))


      (defwidget left []
        (box :orientation "h"
             :space-evenly false
             :halign "start"
          (children)))


      (defwidget center []
        (box :orientation "h"
             :space-evenly false
             :halign "center"
          (children)))

      (defwidget right []
        (box :orientation "h"
             :space-evenly false
             :halign "end"
          (children)))

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
        (centerbox :class "main-container"
          (left
            (workspaces0))

          (center)

          (right
            (yubikey-touch-detector)
            (datetime))))

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
        (centerbox :class "main-container"
          (left
            (workspaces1))

          (center)

          (right
            (yubikey-touch-detector)
            (datetime))))
        
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
        (centerbox :class "main-container"
          (left
            (workspaces2))

          (center)

          (right
            (yubikey-touch-detector)
            (datetime))))
      EOF

      cat <<EOF > $CONFIG_DIR/eww.scss
      * {
        font-family: SauceCodePro NFM Medium;
        font-size: 15px;
      }

      .workspaces {
        border: 1px solid #${config.colorScheme.palette.base05};
        border-left: 0;
      }

      .workspace-button {
        padding: 0 2px;

        border: none;
        border-left: 1px solid #${config.colorScheme.palette.base05};
        border-radius: 0;

        color: #${config.colorScheme.palette.base05};
        background: none;
        box-shadow: none;
      }

      .workspace-active {
        background: #${config.colorScheme.palette.base0F};
      }

      .bar0, .bar1, .bar2 {
        background-color: transparent;

        .main-container {
          margin: 4px 4px 0 4px;
          padding: 2px 5px 2px 0;
          color: #${config.colorScheme.palette.base05};
          background-color: #${config.colorScheme.palette.base00};
        }
      }

      .yubikey-touch-detector {
        margin: 0 10px 0 0;

        label {
          font-size: 18px;
        }

        &--active {
          color: #${config.colorScheme.palette.base08};
        }
      }
      EOF

      echo $CONFIG_DIR
      exit 0
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
