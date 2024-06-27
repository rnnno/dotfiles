#!/bin/bash

# プライマリディスプレイの名前を取得
PRIMARY=$(hyprctl monitors -j | jq -r '.[0].name')

# 接続されているモニターの数を取得
MONITORS=$(hyprctl monitors -j | jq length)

if [ "$MONITORS" -gt 1 ]; then
    # 2つ目のモニターの名前を取得
    SECONDARY=$(hyprctl monitors -j | jq -r '.[1].name')

    # セカンダリモニターをプライマリの右に配置
    hyprctl keyword monitor $SECONDARY,preferred,auto,1,mirror,$PRIMARY
else
    # 単一モニターの場合、デフォルト設定を使用
    hyprctl keyword monitor ,preferred,auto,1
fi
