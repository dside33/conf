from config import (
    IAM_TOKEN,
    FOLDER_ID,
    ZONE,
    SUBNET_ID,
    VM_NAME,
)
import paramiko

import yandexcloud
from yandex.cloud.compute.v1.image_service_pb2 import GetImageLatestByFamilyRequest
from yandex.cloud.compute.v1.image_service_pb2_grpc import ImageServiceStub
from yandex.cloud.compute.v1.instance_pb2 import IPV4, Instance
from yandex.cloud.compute.v1.instance_service_pb2 import (
    AttachedDiskSpec,
    CreateInstanceMetadata,
    CreateInstanceRequest,
    DeleteInstanceRequest,
    NetworkInterfaceSpec,
    OneToOneNatSpec,
    PrimaryAddressSpec,
    ResourcesSpec,
)
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub

from yandex.cloud.compute.v1.instance_service_pb2 import GetInstanceRequest
from yandex.cloud.compute.v1.disk_service_pb2 import GetDiskRequest
from yandex.cloud.compute.v1.disk_service_pb2_grpc import DiskServiceStub
from yandex.cloud.compute.v1.image_service_pb2 import GetImageRequest



def create_instance(sdk, folder_id, zone, name, subnet_id, ssh_public_key):
    image_service = sdk.client(ImageServiceStub)
    source_image = image_service.GetLatestByFamily(
        GetImageLatestByFamilyRequest(folder_id="standard-images", family="ubuntu-2204-lts")
    )
    subnet_id = subnet_id or sdk.helpers.get_subnet(folder_id, zone)
    instance_service = sdk.client(InstanceServiceStub)
    operation = instance_service.Create(
        CreateInstanceRequest(
            folder_id=folder_id,
            name=name,
            resources_spec=ResourcesSpec(
                memory=2 * 2**30,   #2**30 - 1 гб
                cores=2,
                core_fraction=0,
            ),
            zone_id=zone,
            platform_id="standard-v1",
            boot_disk_spec=AttachedDiskSpec(
                auto_delete=True,
                disk_spec=AttachedDiskSpec.DiskSpec(
                    type_id="network-hdd",
                    size=20 * 2**30,
                    image_id=source_image.id,
                ),
            ),
            network_interface_specs=[
                NetworkInterfaceSpec(
                    subnet_id=subnet_id,
                    primary_v4_address_spec=PrimaryAddressSpec(
                        one_to_one_nat_spec=OneToOneNatSpec(
                            ip_version=IPV4,
                        )
                    ),
                ),
            ],
            metadata={
                "user-data": f"""#cloud-config
                users:
                  - name: side
                    ssh-authorized-keys:
                      - {ssh_public_key}
                """
            }
        )
    )
    return operation


def get_instance_info(sdk, instance_id):
    instance_service = sdk.client(InstanceServiceStub)
    instance = instance_service.Get(GetInstanceRequest(instance_id=instance_id))
    
    if instance.boot_disk.disk_id:
        disk_service = sdk.client(DiskServiceStub)
        disk = disk_service.Get(GetDiskRequest(disk_id=instance.boot_disk.disk_id))
        os_image_id = disk.source_image_id if hasattr(disk, 'source_image_id') else None
        
        if os_image_id:
            image_service = sdk.client(ImageServiceStub)
            image = image_service.Get(GetImageRequest(image_id=os_image_id))
            os_image_name = image.description if image.description else "Unknown OS"


    info = {
        "id": instance.id,
        "name": instance.name,
        "zone": instance.zone_id,
        "os_image": os_image_name,
        "ip": instance.network_interfaces[0].primary_v4_address.one_to_one_nat.address,
        "disk_size": disk.size / (2 ** 30),
        "disk_type": disk.type_id,
        "cpu_cores": instance.resources.cores,
        "memory_gb": instance.resources.memory / (2 ** 30)
    }
    return info


def update_ssh_key(ip_address, username, private_key_path, new_public_key):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    client.connect(ip_address, username=username, key_filename=private_key_path)

    command = f'echo "lollol" >> ~/.ssh/authorized_keys'
    client.exec_command(command)

    client.close()


def delete_instance(sdk, instance_id):
    instance_service = sdk.client(InstanceServiceStub)
    return instance_service.Delete(DeleteInstanceRequest(instance_id=instance_id))


def main():

    sdk = yandexcloud.SDK(iam_token=IAM_TOKEN)

    instance_id = None
    try:
        with open('pywm_public.txt', 'r') as f:
            ssh_public_key = f.read().strip()
            print(ssh_public_key)

        operation = create_instance(sdk, FOLDER_ID, ZONE, VM_NAME, SUBNET_ID, ssh_public_key)
        operation_result = sdk.wait_operation_and_get_result(
            operation,
            response_type=Instance,
            meta_type=CreateInstanceMetadata,
        )

        instance_id = operation_result.response.id

    finally:
        if instance_id:
            print("Successfully create")

            info = get_instance_info(sdk, instance_id)
            print(info)

    # with open('pyssh_new.txt', 'r') as f:
    #     new_public_key = f.read().strip()
    # update_ssh_key(info['ip'], 'side', 'pyvm_private', new_public_key)

    # delete_instance(sdk, 'fhmkarlo96ctbqgs6770')

if __name__ == "__main__":
    main()