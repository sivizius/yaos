Structure iso_date
  ;"yyyymmddhhMMssHH"
  date.a[16]
  utc.b
EndStructure
Structure iso_word
  intLE.w
  intBE.w
EndStructure
Structure iso_dword
  intLE.d
  intBE.d
EndStructure
#iso_eNoEmulation = 0
#iso_e12Disk = 1
#iso_e144Disk = 2
#iso_e288Disk = 3
#iso_eHardDisk = 4
#iso_p80x86 = 0
#iso_pPowerPC = 1
#iso_pMac = 2
#iso_tBootRecord = 0
#iso_tPrimaryVolumeDescriptor = 1
#iso_tSupplementaryVolumeDescriptor = 2
#iso_tVolumePartitionDescriptor = 3
#iso_tVolumeDescriptorSetTerminator = 255
#iso_sSector = 2048
Structure iso_eltorito
  type.a ;#iso_tBootRecord
  ident.a[5] ;= »CD001«
  version.a ;= 1 ; 0123456789abcdef0123456   789abcdef
  idSystem.a[32] ;»EL TORITO SPECIFICATION«, padded with 0x00
  null0.a[32] ;reserved, filled with 0x00
  bcSector.d ;absolute sector of boot catalogue -> sector
  null1.a[1973] ;reserved, filled with 0x00
EndStructure
Structure iso_BootCatalogue
  headerID.a ;= 1
  plattformID.a ;#iso_p...
  null0.w ;= 0x0000
  ;               0123456789abcdef01234567
  devName.a[24] ;»BUILD BY SUPER BOTS ARMY«
  checkSum.w ;t = 0
  ;           For k = 0 To 13
  ;             t = t + PeekW(*bc + (k * 2))
  ;           Next
  ;           t = t + 0xAA55
  ;           checkSum = - t
  magic.w ;0xAA55
  bootable.a ;true: 0x88, false: 0x00
  emulation.a ;#iso_e...
  entry.w ;0x07c0
  system.a ;= 0x00
  null1.a ;= 0x00
  sizeImage.w ;number of 512b-sectors to load
  addrImage.d ;absolute 2k-sector to load -> sector
  null2.a[20] ;filled with 0x00
EndStructure
Structure iso_pvd
  type.a ;#iso_tPrimaryVolumeDescriptor
  ident.a[5] ;= »CD001«
  version0.a ;= 0x01
  null0.a ;= 0x00
  idSystem.a[32]
  idVolume.a[32]
  null1.q ;= 0x0000000000000000
  countSectors.iso_dword
  null2.a[32] ;filled with 0x00
  countDisks.iso_word
  
  sizeSectors.iso_word
  sizePathTable.iso_dword
  tblPathLE.d
  tblPathLEopt.d
  tblPathBE.d
  tblPathBEopt.d
  null3.a[34]
  idVolumeSet.a[128]
  publisher_data.a[128]
  preparer_data.a[128]
  application_data.a[128]
  copyrigth_file.a[38]
  abstract_file.a[36]
  bibliographic_file.a[37]
  tCreation.iso_date      ; yyyymmddhhMMssHH,  offUTC*4
  tModification.iso_date  ; yyyymmddhhMMssHH,  offUTC*4
  tExpiration.iso_date    ;»0000000000000000«, offUTC*4
  tEffective.iso_date     ;»0000000000000000«, offUTC*4
  version1.a ;= 0x01
  null4.a[1166] ;filled with 0x00
EndStructure
Structure iso_final
  type.a ;#iso_tVolumeDescriptorSetTerminator
  ident.a[5] ;= »CD001«
  version.a ;= 0x01
EndStructure
;sectors
;0x0000 - 0x000f  system
;0x0010           iso_pvd
;0x0011           iso_eltorito -> 0x12
;0x0012           iso_BootCatalogue -> 0x13
;0x0013 - ?????   image
; IDE Options = PureBasic 5.20 LTS (Linux - x64)
; CursorPosition = 82
; FirstLine = 49
; EnableUnicode
; EnableXP