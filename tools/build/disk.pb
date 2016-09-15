Structure fat12_mbr
  jump.a[3] ;= 0xeb, 0x3c, 0x90 = jmp short 62 : nop
  OEMname.a[8] ;= "mkYAOS.0"
  ssize.w ;sector-size
  csize.b ;cluster-size in sectors
  rscount.w ;number of reserved sectors
  fcount.b ;number of FATs
  rcount.w ;maximum number of entries in root-directory
  scount0.w ;number of sectors of NULL
  media.a ;= 0xf8
  fsize.w ;FAT-size in sectors or NULL
  tsize.w ;track-size in sectors
  hcount.w ;number of heads/sides
  bcount.l ;number of sectors before mbr
  scount1.l ;number of sectors if scount0 = NULL, else scount1 = NULL
  device.a
  null.a ;= 0x00
  sign.a ;= 0x29
  FSid.l ;file-system id
  FSname.a[11] ;file-system name, LSet with SPACE
  FATversion.a[8] ;= "FAT12   "
  bootloader.a[448]
  bootsignature.w ;= 0xAA55
EndStructure
Structure fat12_ctime
  d.a
  t.l
EndStructure
#fat12_f = 0
#fat12_fReadOnly = 1
#fat12_fHidden = 2
#fat12_fSystem = 4
#fat12_fVolumeLabel = 8
#fat12_fDirectory = 16
#fat12_fArchive = 32
#fat12_fReserved0 = 64
#fat12_fReserved1 = 128
Structure fat12_entry
  ;/p/a/t/h/filename.ext ->
  name.a[8] ;<- filename
  ext.a[3] ;<- ext
  flags.a ;= #fat12_f
  null0.a ;= 0x00
  cdate.fat12_ctime ;= cdate(now)
  adate.w ;= adate(now)
  null1.w ;= 0x0000
  wdate.l ;= wdate(now)
  cluster.w ;first cluster
  size.l ;NULL or filesize
EndStructure
Procedure cdate(*entry.fat12_entry, date)
  With *entry
    \cdate\d = (Second(date) & 1) * 100
    \cdate\t = 1<<0  * Hour(date) +
               1<<5  * Minute(date) +
               1<<11 * (Second(date) / 2) +
               1<<16 * (Year(date)-1980) +
               1<<23 * Month(date) +
               1<<27 * Day(date)
  EndWith
EndProcedure
Procedure adate(*entry.fat12_entry, date)
  With *entry
    \adate =   1<<0  * (Year(date)-1980) +
               1<<7  * Month(date) +
               1<<11 * Day(date)
  EndWith
EndProcedure
Procedure wdate(*entry.fat12_entry, date)
  With *entry
    \wdate =   1<<0  * Hour(date) +
               1<<5  * Minute(date) +
               1<<11 * (Second(date) / 2) +
               1<<16 * (Year(date)-1980) +
               1<<23 * Month(date) +
               1<<27 * Day(date)
  EndWith
EndProcedure
Procedure disk(*main)
  *mbr.fat12_mbr = AllocateMemory(SizeOf(fat12_mbr))
  If *mbr
    With *mbr
      \jump[0] = $eb
      \jump[1] = $3c
      \jump[2] = $90
      \OEMname[0] = 'm'
      \OEMname[1] = 'k'
      \OEMname[2] = 'Y'
      \OEMname[3] = 'A'
      \OEMname[4] = 'O'
      \OEMname[5] = 'S'
      \OEMname[6] = '.'
      \OEMname[7] = '0'
      \ssize = 512
      \csize = 1
      \fcount = 2
    EndWith
  Else
    PrintN("cannot allocate memory!")
  EndIf
EndProcedure
; IDE Options = PureBasic 5.20 LTS (Linux - x64)
; CursorPosition = 20
; Folding = -
; EnableUnicode
; EnableXP