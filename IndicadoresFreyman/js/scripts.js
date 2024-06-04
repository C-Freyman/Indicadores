(function (global, undefined) {
    var demo = {};

    function togglePopupModality() {
        var wnd = getModalWindow();

        wnd.set_modal(!wnd.get_modal());
        setCustomPosition(wnd);

        if (!wnd.get_modal()) {
            document.documentElement.focus();
        }
    }

    function setCustomPosition(sender, args) {
        sender.moveTo(sender.getWindowBounds().x, 280);
    }

    function showDialogInitially() {
        var wnd = getModalWindow();

        wnd.show();
        Sys.Application.remove_load(showDialogInitially);
    }
    Sys.Application.add_load(showDialogInitially);

    function getModalWindow() { return $find(demo.modalWindowID); }

    global.$modalWindowDemo = demo;
    global.togglePopupModality = togglePopupModality;
    global.setCustomPosition = setCustomPosition;
})(window);
