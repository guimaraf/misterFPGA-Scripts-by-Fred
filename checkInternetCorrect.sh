check_internet() {
    log "Checking internet connection..."

    if ping -4 -q -c 1 -W 3 1.1.1.1 >/dev/null 2>&1 || \
       ping -4 -q -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
        log "Internet connection is available." SUCCESS
        return 0
    fi

    if wget -q --spider --timeout=5 https://www.google.com/generate_204; then
        log "Internet connection is available." SUCCESS
        return 0
    fi

    log "No internet connection detected." ERROR
    exit 1
}