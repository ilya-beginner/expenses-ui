function formatType(sum) {
    if (sum < 0) {
        return String.fromCodePoint(0x1F4B8);
    }
    else {
        return String.fromCodePoint(0x1F4B0);
    }
}
