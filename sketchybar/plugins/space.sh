# #!/bin/bash
# if [ "$SELECTED" = "true" ]; then
#   sketchybar --set "$NAME" background.drawing=on \
#                           label.color=0xff000000    # Black text on bright blue
# else
#   sketchybar --set "$NAME" background.drawing=off \
#                           label.color=0xff00aeff    # Bright blue text when inactive
# fi
#!/bin/bash

if [ "$SELECTED" = "true" ]; then
    sketchybar --set $NAME background.drawing=on \
                          icon.color=0xff1e2326
else
    sketchybar --set $NAME background.drawing=off \
                          icon.color=0xffd3c6aa
fi
