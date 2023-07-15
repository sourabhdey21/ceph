after firing the script there will be some troubleshooting has to be done 
ceph osd pool set .mgr size 1 --yes-i-really-mean-it
ceph config set global mon_allow_pool_size_one true
ceph health mute POOL_NO_REDUNDANCY



## if that will not work try to delete rbd pool and recreate it 
https://hackmd.io/@yujungcheng/B1lCV3UH9     <----- Refrence 
![image](https://github.com/sourabhdey21/ceph/assets/98477908/c0d08fdc-0444-4946-96df-a659c84242dc)


![image](https://github.com/sourabhdey21/ceph/assets/98477908/8fdea237-aaaa-4e47-bffa-deca41a6c3b7)

