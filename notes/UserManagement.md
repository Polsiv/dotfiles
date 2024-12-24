# adduser
- `adduser <username>`

# deluser
- `deluser --remove-home <username>`


# usermod
- `usermod -l <loginname> -d <new_home_directory> current_user`

# passwd
- `passwd -l`: locks the user
- `passwd -u`: unlicks the user

# who
- `who -u`: list the connected users and the date

# su 
- `su -c <cmd> <user>`: executes the cmd as the user

# sudo
- `sudo -u <user> <cmd>`: exectues the cmd as the user (and displays the info as if we where the user)
- `sudo -s`: obtain a shell as root

# finger
- `finger <username>`: displays user info

