# Implementierung einer API für die Orchestrierung einer Cloud-Infrastruktur

Tim Meusel – TI114 – Sommer 2015

---

## Inhaltsverzeichnis
+ Projektbeschreibung
  - Hypervisor
  - Cloud Instanzen
  - Netzwerkinterfaces
  - Storage
  - ToDo
+ Entity Relationship Modell
+ Use Cases
  - Definieren von Virtualisierungstechniken
  - Hinzufügen von Nodes
  - Hinzufügen eines IPv4 Netzes
  - Eintragen einer virtuellen Maschine

---

## Projektbeschreibung
Auf Basis von Open-Source-Software soll eine API erstellt werden. Diese soll eine automatisierte Orchestrierung einer dynamischen Cloud Infrastruktur ermöglichen. Verwaltet werden sollen zum einen die verschiedenen Hypervisor als auch die eigentlichen Cloud Instanzen sowie das Netzwerk. Um einen sicheren Betrieb der API zu gewährleisten wird diese redundant und skalierbar gebaut. Außerdem wird stark auf die IT-Sicherheit geachtet da die API nicht nur intern zu administration genutzt wird sondern Kunden darüber autark Änderungen Ihrer Instanzen triggern können.

### Hypervisor
Wenn von einem Hypervisor (Tabelle node) gesprochen wird, bezieht man sich meist auf das physische Hostsystem für eine beliebige Anzahl von Cloud Instanzen (Nova Node im Openstack Jargon). Jeder Hypervisor kann verschiedene Virtualisierungstechniken nutzen (Tabelle hypervisor). Er besitzt grundsätzlich einen Dual-Stack, seine Netzwerkanbindung kann via Bonding/Etherchannel erfolgen. Lokaler Storage für virtuelle Maschinen kann über thin provisioned LVM erfolgen (Attribut vg_name) oder als raw/QCOW2 Image (Attribut local_storage_path). In beiden Fällen wird der lokal belegbare Speicher definiert (Attribut local_storage_gb). Verteilter Storage (Tabelle storage und storage_ceph) steht in keiner Relation zum Hypervisor.Jeder Hypervisor muss sich in einem definierten Zustand befinden (Attribut state_id, Tabelle node_state), Beispiele dafür sind „Running“, „Offline“, „Repair“, „Maintenance“.

### Cloud Instanzen
Jede Instanz (Tabelle vm) hat eine fest definierte Anzahl an Ressourcen (Attribute ram und cores), mindestens einen persistensten Storage (Tabelle storage*) sowie mindestens eine NIC (Tabelle vm_interface). Zu jeder Netzwerkkarte können mehrere VLANs (Tabelle vlan) gehören und mindestens eine IP-Adresse (Tabellen ipv4 und ipv6).Damit der Kunde stehts den aktuellen Status seiner Instanz abfragen kann wird dieser ebenfalls im Vorfeld definiert und in der Datenbank festgehalten (Attribut state_id und Tabelle vm_state). Die Zuordnung zum Kunden erfolgt über seine ID (Attribut customer_id) welche in der Kundendatenbank definiert ist (nicht Bestandteil dieses Projekts). Um eine zu hohe Ressourcennutzung in einer Public Cloud Infrastruktur zu vermeiden kann unter anderem ein Limit (Attribut cputime_limit) für die zur Verfügung stehende CPU Zeit gesetzt werden.

### Netzwerkinterfaces
Der Name eines virtuellen Interfaces (Tabelle vm_interface) setzt sich zusammen aus der ID der VM (Attribut vm_id), gefolgt von einem Bindestrich und dann der Id (Attribut id) der Interfaces. Jedem Interface wird eine eigene Bridge zugeordnet mit dem Präfix br-. Via VXLAN werden VLANs zwischen den Interfaces realisiert. Jedes in der Datenbank definierte VLAN (Tabelle vlan) terminiert an jeder Bridge dessen Interface zum VLAN gehört. Dies ermöglicht es Kunden gesicherte Layer2 Verbindungen zwischen Ihren Instanzen beliebig zu generieren. Die IP-Adressen (Tabelle ipv4 und ipv6) werden auf die entsprechenden Bridges geroutet. Um eine feste IP<>MAC Zuordnung zu realisieren wird zu jedem Interface die MAC gespeichert (Attribut mac).

### Storage
Ein Storage (Tabelle storage) ist immer an eine Instanz gebunden und kann nicht von mehreren parallel genutzt werden. Mehrere Storage Typen sind möglich (Tabelle storage_type), z.B. LVM oder QCOW2. Jede Instanz kann beliebig viele Storage Einheiten von beliebigen Typen besitzen. Zu jeder Einheit gehört eine definierte Größe (Attribut size). Um auch hier eine Ressourceneinhaltung zu gewähren können diverse Limits gesetzt werden (Attribute write_iops_limit, read_iops_limit, write_mbps_limit, read_mbps_limit). Typenspezifische Attribute werden in den Tabellen storage_$typ gespeichert, diese besitzen die gleiche Id wie die eigentliche Entity in der Tabelle storage. Um auf die verschiedenen Kundenwünsche einzugehen (besonders schnellen oder sicheren Storage) kann die Cacheoption (Attribut cache_option_id und Tabelle cache_option) pro Storage Einheit gesetzt werden.

### ToDo
In Folgenden Revisionen werden einige neue Features benötigt, unter anderem:
+ Zeitgesteuerte und planbare Backups pro Instanz
+ Dediziertes Backupnetz an jedem Hypervisor
+ Dediziertes Storagenetz an jedem Hypervisor
+ Snapshots von Storage Einheiten

---

## Entity Relationship Modell

---

## Use Cases

### Definieren von Virtualisierungstechniken

### Hinzufügen von Nodes

### Hinzufügen eines IPv4 Netzes

### Eintragen einer virtuellen Maschine
