# /etc/zprofile の path_helper が PATH を組み直すため、その後に再適用して優先順位を戻す
path=($tool_paths $path)
