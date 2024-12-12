# https://github.com/microsoft/WSL/issues/4699
wsl --shutdown
cd ~\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState
Optimize-VHD -Path ext4.vhdx -Mode Full
