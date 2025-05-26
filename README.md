# Mail: Removing

Deleting emails by a specified regular expression.

## Install

```bash
export SET_DIR='/root/apps/mail'; export GH_NAME='bash-mail-rm'; export GH_URL="https://github.com/pkgstore/${GH_NAME}/archive/refs/heads/main.tar.gz"; curl -Lo "${GH_NAME}-main.tar.gz" "${GH_URL}" && tar -xzf "${GH_NAME}-main.tar.gz" && { cd "${GH_NAME}-main" || exit; } && { for i in app.*; do install -m 644 -Dt "${SET_DIR}" "${i}"; done; } && { for i in cron_*; do install -m 644 -Dt '/etc/cron.d' "${i}"; done; } && chmod +x "${SET_DIR}"/*.sh
```

## Resources

- [Documentation (RU)](https://lib.onl/)
