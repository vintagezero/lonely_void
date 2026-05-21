import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class lonelyvoidView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {
    }


    function onUpdate(dc as Dc) as Void {
        (View.findDrawableById("void") as WatchUi.Text).setText("$ v o i d");
    
        
        View.onUpdate(dc);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

}
