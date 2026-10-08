function task_dependencies() {
  outout_nl \
    eac_ce \
    ehb_ubuntu_base1 \
    ehb_ubuntu_base0/debian_packages \
    ehb_ubuntu_base0/git_with_keyring \
    ehb_ubuntu_base0/mkusb \
    ehb_ubuntu_base0/printing \
    ehb_ubuntu_base0/snap_packages \
    ehb_ubuntu_base0/vscode \
    ehb_ubuntu_base0/vscode_taskbar_launcher
}

function task_condition() {
  return
}
