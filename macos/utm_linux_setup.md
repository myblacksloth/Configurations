# Configurare UTM su macOS con Guest Linux

- [Configurare UTM su macOS con Guest Linux](#configurare-utm-su-macos-con-guest-linux)
- [Installazione dei driver guest](#installazione-dei-driver-guest)
- [Configurazione dei permessi sudo](#configurazione-dei-permessi-sudo)
- [Configurare la cartella condivisa in UTM](#configurare-la-cartella-condivisa-in-utm)
- [Shared mount](#shared-mount)
  - [Creare la cartella di mount](#creare-la-cartella-di-mount)
  - [Configurare /etc/fstab](#configurare-etcfstab)
  - [Ricaricare systemd](#ricaricare-systemd)
  - [Mount manuale di tutto (fstab)](#mount-manuale-di-tutto-fstab)
- [Shared mount manuale diretto](#shared-mount-manuale-diretto)
- [Test della condivisione](#test-della-condivisione)
- [Note](#note)


# Installazione dei driver guest

Una volta avviata la VM Linux, installare i driver che permettono una migliore integrazione con UTM

``` bash
sudo apt update
sudo apt install spice-vdagent qemu-guest-agent
```

Questi pacchetti permettono:

-   integrazione del mouse
-   miglior gestione dello schermo
-   comunicazione tra host e guest

------------------------------------------------------------------------

# Configurazione dei permessi sudo

``` bash
sudo vim /etc/sudoers
```

Aggiungere:

```
username ALL=(ALL) ALL
```

------------------------------------------------------------------------

# Configurare la cartella condivisa in UTM

Nel pannello di configurazione della VM:

1.  Spegnere la VM
2.  **Settings**
3.  **Sharing**
4.  Aggiungere una cartella macOS
5.  Imposta il nome:

    share

Questa deve corrispondere alla configurazione in `/etc/fstab`.

------------------------------------------------------------------------

# Shared mount

## Creare la cartella di mount

``` bash
sudo mkdir /mnt/utm
```

## Configurare /etc/fstab

``` bash
sudo vim /etc/fstab
```

```
share /mnt/utm 9p trans=virtio,version=9p2000.L,rw,_netdev,nofail,auto 0 0
```

Ovvero:

```
parametro      descrizione
-------------- -------------------------------
share          nome della cartella condivisa
/mnt/utm       punto di mount
9p             filesystem virtio
trans=virtio   protocollo virtio
rw             lettura/scrittura
\_netdev       mount dopo la rete
nofail         non blocca il boot
```

## Ricaricare systemd

``` bash
sudo systemctl daemon-reload
```

Verificare i mount:

``` bash
systemctl list-units --type=mount
```

## Mount manuale di tutto (fstab)

``` bash
sudo mount -a
```

La cartella condivisa sarà disponibile in:

    /mnt/utm

------------------------------------------------------------------------

# Shared mount manuale diretto

```bash
sudo mount -t 9p -o trans=virtio,version=9p2000.L share /mnt/utm
```

------------------------------------------------------------------------

# Test della condivisione

``` bash
ls /mnt/utm
```

# Note

Fix permessi:

``` bash
sudo chmod 777 /mnt/utm
```

oppure usare uid/gid nelle opzioni di mount
