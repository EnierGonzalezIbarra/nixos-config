{ pkgs, lib, inputs, username, ... }:
{
  services = {
    mpdris2.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "/home/enier/Music";
      network.startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
        }
      '';
    };
  };

  home.packages = with pkgs; [
    libnotify
    ffmpeg
    mpc-cli
    (pkgs.writeScriptBin "songinfo" ''
      music_dir="$HOME/Music"
      previewdir="$XDG_CONFIG_HOME/ncmpcpp/previews"
      mkdir -p "$previewdir"
      filename="$(mpc --format "$music_dir"/%file% current)"
      previewname="$previewdir/$(mpc --format %album% current | base64).png"

      [ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null 2>&1

      notify-send -r 27072 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current)" -i "$previewname"
    '')
  ];
  programs = {
    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      bindings = [
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "h"; command = "previous_column"; }
        { key = "l"; command = "next_column"; }
      ];
      settings = {
        "colors_enabled" = "yes";
        "playlist_editor_display_mode" = "columns";
        "playlist_display_mode" = "columns";
        "search_engine_display_mode" = "columns";
        "user_interface" = "alternative";
        "main_window_color" = "magenta";
        "progressbar_color" = "white";
        "current_item_prefix" = "$(cyan)$r";
        "current_item_suffix" = "$/r$(end)";
        "current_item_inactive_column_prefix" = "$(magenta)$r";
        "volume_color" = "green";
        "progressbar_elapsed_color" = "cyan";
        "execute_on_song_change" = "songinfo";
        "lyrics_fetchers" = "musixmatch, sing365, metrolyrics, justsomelyrics, jahlyrics, plyrics, tekstowo, zeneszoveg, internet";
      };
    };
  };
}
