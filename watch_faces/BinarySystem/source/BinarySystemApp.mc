using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class BinarySystemApp extends App.AppBase {

	var mView = new BinarySystemView();

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ mView ];
    }

    //! New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        Ui.requestUpdate();
        mView.onSettingsChanged();
    }

}