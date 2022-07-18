{ pkgs, ...}:

{
#  home.packages = with pkgs; [
#    glib gsettings-desktop-schemas
#    gnome3.adwaita-icon-theme
#  ];

#  home.sessionVariables = {
#    XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS";
#  };

#  gtk = {
#    enable = false;

#    theme = {
#      name = "Adwaita";
#      package = pkgs.nordic;
#    };

#    iconTheme = {
#      name = "Adwaita";
#      package = pkgs.gnome3.adwaita-icon-theme;
#    };

#    cursorTheme = {
#      name = "Adwaita";
#      package = pkgs.paper-icon-theme;
#    };
#  };
}
