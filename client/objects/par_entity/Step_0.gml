if (global.server.admin_username != global.server.username) {
    if (x == _x && y == _y) return;
        
    var xgap = (_x - x)
    var ygap = (_y - y)
    
    if (abs(xgap) < 0.05) {
        x = _x
    } else {
        x += xgap / 3
    }
    
    if (abs(ygap) < 0.05) {
        y = _y
    } else {
        y += ygap / 3
    }
}