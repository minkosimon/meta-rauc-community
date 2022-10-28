fdt addr ${fdt_addr} && fdt get value bootargs /chosen bootargs
echo "[  U-BOOT ] : bootgars = $bootargs"
test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3
test -n "${BOOT_DEV}" || setenv BOOT_DEV "mmc 0:1"
setenv bootpart
setenv raucslot
echo "[  U-BOOT ] : BOOT_ORDER = ${BOOT_ORDER}"
echo "[  U-BOOT ] : BOOT_A_LEFT = ${BOOT_A_LEFT}"
echo "[  U-BOOT ] : BOOT_B_LEFT = ${BOOT_B_LEFT}"
echo "[  U-BOOT ] : bootpart = ${bootpart}"
echo "[  U-BOOT ] : raucslot = ${raucslot}"
for BOOT_SLOT in "${BOOT_ORDER}"; do \
if test "x${bootpart}" != "x"; then \
    echo "skip remaining slots" ;\
  elif test "x${BOOT_SLOT}" = "xA"; then \
    if test ${BOOT_A_LEFT} -gt 0; then \
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1 ;\
      echo "Found valid RAUC slot A"; \
      setenv bootpart "/dev/mmcblk0p2" ;\
      setenv raucslot "A" ;\
      setenv BOOT_DEV "mmc 0:2"; \
    fi ;\
  elif test "x${BOOT_SLOT}" = "xB"; then \
    if test ${BOOT_B_LEFT} -gt 0; then \
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1 ;\
      echo "Found valid RAUC slot B" ;\
      setenv bootpart "/dev/mmcblk0p3" ;\
      setenv raucslot "B" ;\
      setenv BOOT_DEV "mmc 0:3" ;\
    fi;\
  fi;\
done;\
if test -n "${bootpart}"; then \
  setenv bootargs "${bootargs} root=${bootpart} rauc.slot=${raucslot}"; \
  saveenv;\
else \
  echo "No valid RAUC slot found. Resetting tries to 3"; \
  setenv BOOT_A_LEFT 3; \
  setenv BOOT_B_LEFT 3; \
  saveenv; \
  reset; \
fi; \
setenv bootargs console=ttyAMA0 root=/dev/mmcblk0p2;saveenv;ext4load mmc 0:1 0x60100000 zImage;ext4load mmc 0:1 0x62000000 vexpress-v2p-ca9.dtb;bootz 0x60100000 - 0x62000000
