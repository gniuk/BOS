;----------------------------------------------------------;
; BOS kernel                Christoffer Bubach, 2012-2015. ;
;----------------------------------------------------------;
;                                                          ;
;        VFS handling all devices and filesystems.         ;
;                                                          ;
;----------------------------------------------------------;


    ; file handles need to be dword, where the high
    ; word contains drive number, and the low word
    ; is the drive/FS specific handle. limits FS to
    ; a max of 65535 opened files. should be alright. ;)


    ;---------------------------------------------;
    ;   VFS main structure                        ;
    ;---------------------------------------------;
    struc VFS
    {
        .number:                times 255      db 0   ; 00=FD, 0x10=HD, 0x60=CD, 0x80=VD, 90=RD, B0=ND
        .storage:
            times 255 * sizeof.VFS_storage     db 0   ; storage driver structure
        .filesystem:          
            times 255 * sizeof.VFS_filesystem  db 0   ; filesystem driver structure
        .mounted                               db 0   ; 1/0 switch if mounted
        .current_path:          times 255      db 0   ; drive opened path (increase max path size?)
    }

    virtual at 0                                      ; could use "at esi" instead
        VFS VFS
        sizeof.VFS = $-$$     
    end virtual

    ;---------------------------------------------;
    ;   VFS storage driver structure              ;
    ;---------------------------------------------;
    struc VFS_storage
    {
        .data_pointer         dd  0                   ; internal driver data
        .init                 dd  0                   ; pointer to init
        .deinit               dd  0                   ; remove driver
        .read                 dd  0                   ; read device
        .write                dd  0                   ; write device
        .ioctl                dd  0                   ; handle device specific extras
    }

    virtual at 0
        VFS_storage VFS_storage
        sizeof.VFS_storage = $-$$
    end virtual

    ;---------------------------------------------;
    ;   VFS filesystem structure                  ;
    ;---------------------------------------------;
    struc VFS_filesystem
    {
        .data_pointer         dd  0                   ; internal driver data
        .init                 dd  0                   ; pointer to init
        .deinit               dd  0                   ; remove driver
        .format               dd  0                   ; format drive
        .mount                dd  0                   ; mount drive
        .unmount              dd  0                   ; unmount drive
        .find                 dd  0                   ; find file
        .findnext             dd  0                   ; get next match
        .open                 dd  0                   ; open file, get handle
        .read                 dd  0                   ; read file from handle
        .write                dd  0                   ; write file from handle
        .seek                 dd  0                   ; seek from handle
        .remove               dd  0                   ; remove file/dir
        .create               dd  0                   ; create file/dir
        .ioctl                dd  0                   ; extra calls if exists
    }

    virtual at 0
        VFS_filesystem VFS_filesystem
        sizeof.VFS_filesystem = $-$$
    end virtual

    ;---------------------------------------------;
    ;   VFS structure pointer                     ;
    ;---------------------------------------------;
    VFS_structure             dd 0


;--------------------------------------------------------------;
;   init_vfs  -  detect connected drives                       ;
;--------------------------------------------------------------;
;                                                              ;
;       out:                    cf = set if failed             ;
;                                                              ;
;--------------------------------------------------------------;
init_vfs:
        push   eax
        push   ebx

        mov    ebx, sizeof.VFS                        ; allocate structure size
        call   allocate_mem
        cmp    eax, 0
        jne    .ok
        stc                                           ; if error, set carry
        mov    ebx, 0

    .ok:
        mov    dword [VFS_structure], ebx

        pop    ebx
        pop    eax
        ret

;--------------------------------------------------------------;
;   add_media  -  add media driver                             ;
;--------------------------------------------------------------;
;                                                              ;
;       in:  reg = pointer to VFS drive info                   ;
;                                                              ;
;       out: reg = pointer to struct(s) if FAT12 found         ;
;                                                              ;
;--------------------------------------------------------------;
add_media:
        push   eax
        ;...
        pop    eax
        ret

;--------------------------------------------------------------;
;   add_fs  -  add filesystem driver                           ;
;--------------------------------------------------------------;
;                                                              ;
;       in:  reg = pointer to VFS drive info                   ;
;                                                              ;
;       out: reg = pointer to struct(s) if FAT12 found         ;
;                                                              ;
;--------------------------------------------------------------;
add_fs:
        push   eax
        ;...
        pop    eax
        ret