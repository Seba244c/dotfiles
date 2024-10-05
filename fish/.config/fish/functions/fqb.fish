function fqb
    ssh -t 192.168.86.44 'sudo docker restart qbittorrent; bash -l'
end
