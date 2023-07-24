# Примеры автоматической сборки образов ВМ с помощью Packer

В этом репозитории представлены конфигурации для сборки образов виртуальных машин для разворачивания в Timeweb Cloud для сборочной системы [Hashicorp Packer](https://developer.hashicorp.com/packer).

Для корректной работы образа необходимо соблюдение условий, перечисленных в статье [Подготовка образа для создания облачного сервера](https://timeweb.cloud/docs/unix-guides/podgotovka-obraza-dlya-sozdaniya-oblachnogo-servera).

# Подготовка к сборке

Перед началом работы вам необходимо установить на компьютер все необходимые инструменты. Сборка была протестирована на Windows и Arch Linux.

Если хостовая машина на Windows скачайте и установите [QEMU](https://qemu.weilnetz.de/w64/) и [Packer](https://developer.hashicorp.com/packer/downloads?product_intent=packer).

На сборки на Linux-хосте требуется установить стек QEMU/KVM. Имена пакетов могут различаться от дистрибутива к дистрибутиву.

Пакеты для Arch Linux:

- `packer`
- `libvirt`
- `iptables-nft`
- `dnsmasq`
- `qemu-desktop`

Пакеты для Debian:

- [`packer`](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli#installing-packer)
- `qemu-system`
- `dnsmasq`
- `libvirt-clients`
- `libvirt-daemon-system`
- `virtinst`

# Сборка образа Debian

Команда для сборки образа:

```
packer build \
    -var iso_url=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.1.0-amd64-netinst.iso \
    -var iso_checksum=9da6ae5b63a72161d0fd4480d0f090b250c4f6bf421474e4776e82eea5cb3143bf8936bf43244e438e74d581797fe87c7193bbefff19414e33932fe787b1400f \
    debian.pkr.hcl
```

Будет создан образ с Debian 12. Конфиги из этого репозитория также были протестированы с Debian 10 и 11.

Пароль root задатся в файле [preseed.cfg](debian/preseed.cfg) и в [debian.pkr.hcl](debian/debian.pkr.hcl).

Документация: https://wiki.debian.org/DebianInstaller/Preseed

# Сборка образа Windows Server 2019

В примере использован [этот образ](http://mirror.timeweb.ru/win/) Windows Server 2019 вместе с [образом VirtIO](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.229-1/).

Команда для сборки:

```
packer build \
    -var iso_url=SW_DVD9_Win_Server_STD_CORE_2019_1809.7_64Bit_Russian_DC_STD_MLF_X22-38349.ISO \
    -var iso_checksum=bb64638c34c4e311bcd080c5f02eb6fcd0908f5d6e6e6528fb30862ba0e9cdac \
    -var iso_virtio=virtio-win-0.1.229.iso \
    windows.pkr.hcl
```

Если вы хотите собрать англоязычный вариант ОС используйте файл `windows_en.pkr.hcl`.

Пароль администратора в этом примере — `packer`. Задаётся в файлах [Autounattend.xml](windows/Autounattend.xml) (внутри объекта `AdministratorPassword`) и в [windows.pkr.hcl](windows/windows.pkr.hcl). Также создаётся временный пользователь `packer` с автоматическим логином для настройки образа, он удаляется из системы и в готовом образе отсутсвует.

Обратите внимание, что при сборке указывается объём виртуального диска 40 Гб. При установке ВМ в Timeweb Cloud вы должны выбрать диск не меньшего объёма.

Документация: https://learn.microsoft.com/ru-ru/windows-hardware/manufacture/desktop/windows-setup-automation-overview
