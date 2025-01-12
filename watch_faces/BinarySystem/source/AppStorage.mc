using Toybox.Application as App;

class AppStorage {

    static var app;
    static function setApp(application){
        app = application;
    }

    static function getProperty(propName) {
        if ( Toybox.Application has :Properties ) {
            return App.Properties.getValue(propName);
        }
        else {
            return app.getProperty(propName);
        }
    }
}
