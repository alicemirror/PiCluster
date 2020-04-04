# 
# How to get rid of the locale warning on raspberry pi
# then enabling and starting slurm
# 
#sudo sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" -i /etc/locale.gen
#sudo locale-gen en_US.UTF-8
sudo update-locale en_US.UTF-8

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

sudo systemctl enable munge
sudo systemctl start munge

sudo systemctl enable slurmd
sudo systemctl start slurmd
