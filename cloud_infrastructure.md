#Implementing a KVM based Cloud Infrastructure

QEMU is one of the industry standard hypervisors for full hardware virtualization. It is licensed under the GNU GPL2, a common open source license and used by SUSE and RedHat in there cloud products. QEMUs KVM addon allows for paravirtualized hardware instead of fully emulating it. Due to the paravirualization the overhead compared to real hardware is only around five to ten percent.

A cloud infrastructure with QEMU/KVM offers several features:
+ Open Source → no license costs
+ Live increase number of vCPUs
+ Hot add memory
+ Kernel samepage merging (KSM) for memory overcommitment (PCS can't do that)
+ Memory ballooning (only allocate used ram, release free ram)
+ Support for local, central and shared storage
+ Block devices only allocate used space → efficient storage usage with overcommiting
+ Supports every operating system inside virtual maschines
+ Migrating VMs from one hostsystem to another one with different CPUs
+ wide tested and stable hypervisor

QEMU with KVM is very efficient. This includes the memory footprint for each VM, the CPU overhead and the block storage. Parallels Cloud Server is a widly used alternative to QEMU, a short comparison: PCS allocates all memory that a virtual maschine has configured at the VM boot, additionally PCS has memory leaks and allocates more and more RAM during the runtime of a VM. QEMU only allocates the memory that a VM uses, also it releases unused memory. Parallels ploop storage format allocates up to 1MB of disk space for a 4k block inside a VM (which is a unnecessary waste of disk space), also deleted blocks are just marked as deleted but still allocated, so the ploop file can grow until the hard disk is full (another unnecessary waste). QEMU supports thin provisioned storage which is able to free up deleted blocks, so the storage file only allocates its actual size or its defined size. Based on benchmarks and experience it is no problem to run 70-100 KVM instances on one Dell R720XD with two E5-2620v2, 256gb of RAM and 12 Disks (7200rpm SAS) as a Raid50 Setup. The limiting factor is the disk space, 100-120 virtual maschines can be handled by the CPUs and RAM if the server has enough disk space.

QEMU is a great and powerfull hypervisor, but it doesn't offer any RESTfull like interfaces for management. As part of my computer engineering studying, I created a draft for an API. This draft is available at: https://github.com/virtapi/virtapi

Right now it offers:
+ The relationships between resources, displayed as an ERD
+ A list of requirements for the API itself and the created infrastructure
+ A comparision of alternative projects and an explanation why they aren't suitable for big cloud environments

This setup was acquired and reviewed by multiple system engineers and currently covers all their needs. The focus is on managing a QEMU platform with puppet or salt, industry standard configuration and lifecycle management applications. Other hypervisors are implemented, too to support a migration to QEMU in the long range.

QEMU supports a wide range of blockdevice types, the local ones being QCOW2, RAW images or LVM2 volumes. The API will support those and additiional Ceph for RAW images. Ceph is a distributed block and object store, which supports high availability and infinite scaling. To reduce the demand for a fast network, Ceph can be deployed to the same hardware nodes as the hypervisor. This will reduce the network requirements up to 50 percent. It is easy to increase the storage amount or the throughput by adding more OSDs or journal SSDs. Live virtual machine migration takes less time because one only need to sync the virtual memory and not the whole local storage. Compared to local storage on multiple hypervisors, Ceph is able to use the harddisks and SSDs more efficient.

In my opinion, it should be possible to develop this API including the cloud infrastrucute with two developers and one or two system engineers in 8 weeks. This should be enough time to develop a working environment that is able to deploy and modify virtual maschines via a RESTfull API or the corresponding webinterface.
