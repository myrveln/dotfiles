#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/common.sh"

aws_ssm_proxy_url="https://raw.githubusercontent.com/qoomon/aws-ssm-ssh-proxy-command/refs/heads/main/aws-ssm-ssh-proxy-command.sh"
aws_ssm_proxy_dir="${HOME}/.ssh/aws-ssm-ssh-proxy-command"
aws_ssm_proxy_path="${aws_ssm_proxy_dir}/aws-ssm-ssh-proxy-command.sh"

if ! command -v curl >/dev/null 2>&1; then
    log_warn "curl not found; skipping AWS SSM SSH proxy helper download."
    exit 0
fi

if [[ -x "${aws_ssm_proxy_path}" ]]; then
    tmp_path="$(mktemp)"
    http_code="$(curl -fsSL -z "${aws_ssm_proxy_path}" -w "%{http_code}" -o "${tmp_path}" "${aws_ssm_proxy_url}" || true)"

    if [[ "${http_code}" == "200" ]]; then
        if ! cmp -s "${tmp_path}" "${aws_ssm_proxy_path}"; then
            mv "${tmp_path}" "${aws_ssm_proxy_path}"
            chmod 0755 "${aws_ssm_proxy_path}"
            log_info "AWS SSM SSH proxy helper updated at ${aws_ssm_proxy_path}"
        fi
    elif [[ "${http_code}" != "304" ]]; then
        log_warn "could not refresh AWS SSM SSH proxy helper at ${aws_ssm_proxy_path}"
    fi

    rm -f "${tmp_path}"
    exit 0
fi

read -p "Download AWS SSM SSH proxy helper? (y/n) " -n 1
printf '\n'
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    mkdir -p "${aws_ssm_proxy_dir}"
    curl -fsSL "${aws_ssm_proxy_url}" -o "${aws_ssm_proxy_path}"
    chmod 0755 "${aws_ssm_proxy_path}"
    log_info "AWS SSM SSH proxy helper downloaded to ${aws_ssm_proxy_path}"
else
    log_skip "AWS SSM SSH proxy helper download not selected."
fi
