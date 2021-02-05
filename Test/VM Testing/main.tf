provider "azurerm" {
    features {}
}

locals {
    vm = {
      publisher = "MicrosoftSharePoint"
      offer     = "MicrosoftSharePointServer"
      sku       = "sp2019"
      version   = "latest"
      vm_size   = "Standard_B1s"
      admin_username = "azureadmin"
      admin_password = "adminadmin123!"
    }

    vm1 = {
      vmname = "SPVMTest01"
    }
}

# Resource Group
resource "azurerm_resource_group" "rg_vm_001" {
    name = "rg-vm-001"
    location = "northeurope"
}

# Virtual Network

resource "azurerm_virtual_network" "vm_test_vnet" {
    name = "vm-test-vnet"
    location = azurerm_resource_group.rg_vm_001.location
    resource_group_name = azurerm_resource_group.rg_vm_001.name
    address_space = [ "10.0.0.0/16" ]


}

# Subnet

resource "azurerm_subnet" "snet_vm_test" {
    depends_on = [ azurerm_virtual_network.vm_test_vnet ]
    name = "snet-vm-test"
    resource_group_name = azurerm_resource_group.rg_vm_001.name
    virtual_network_name = azurerm_virtual_network.vm_test_vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

### VM1

resource "azurerm_network_interface" "vm_001" {
  name                = "${local.vm1.vmname}-nic"
  location            = azurerm_resource_group.rg_vm_001.location
  resource_group_name = azurerm_resource_group.rg_vm_001.name

  ip_configuration {
    name                          = "${local.vm1.vmname}-ipconfig"
    subnet_id                     = azurerm_subnet.snet_vm_test.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm_001" {
  name                  = local.vm1.vmname
  location              = azurerm_resource_group.rg_vm_001.location
  resource_group_name   = azurerm_resource_group.rg_vm_001.name
  network_interface_ids = [azurerm_network_interface.vm_001.id]
  vm_size               = local.vm.vm_size 

  storage_image_reference {
    publisher = local.vm.publisher
    offer     = local.vm.offer
    sku       = local.vm.sku
    version   = local.vm.version
  }

  storage_os_disk {
    name              = "${local.vm1.vmname}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 256
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = local.vm1.vmname
    admin_username = local.vm.admin_username
    admin_password = local.vm.admin_password
  }
  
  os_profile_windows_config {

  }

  storage_data_disk {
        caching             = "ReadWrite"
        name                = "${local.vm1.vmname}-datadisk-001"
        create_option       = "Empty"
        disk_size_gb        = 512
        managed_disk_type   = "Premium_LRS"
        lun                 = 0
  }

  primary_network_interface_id = azurerm_network_interface.vm_001.id

}


