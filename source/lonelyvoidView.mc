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
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;

        var date = Time.now();
        var info = Time.Gregorian.info(date, Time.FORMAT_MEDIUM);
        var monthStr = info.month.toUpper();
        var dayNum = info.day;
        var dayStr = info.day_of_week.toUpper();

        var stats = System.getSystemStats();
        var battery = stats.battery.toNumber();

        var actInfo = ActivityMonitor.getInfo();
        var distance = 0.0;
        var bodyBattery = "---";
        var sleepScore = "---";

        var timeString = Lang.format("$1$:$2$", [
            hours.format("%02d"),
            minutes.format("%02d")
        ]);

        var dateString = Lang.format("$1$ $2$ $3$", [
            monthStr,
            dayNum.format("%02d"),
            dayStr
        ]);

        var batteryString = Lang.format("[ $1$% ]", [
            battery
        ]);

        if (actInfo.distance != null) {
            distance = actInfo.distance / 100000.0;
        }

        var distString = Lang.format("[ $1$km ]", [
            distance.format("%.2f")
        ]);

        if (actInfo has :bodyBattery && actInfo.bodyBattery != null) {
            bodyBattery = actInfo.bodyBattery;
        }
        
        var bbString = Lang.format("[ BB: $1$ ]", [
            bodyBattery
        ]);

        if (actInfo has :sleepScore && actInfo.sleepScore != null) {
            sleepScore = actInfo.sleepScore;
        }

        var sleepString = Lang.format("[ SLP: $1$ ]", [
            sleepScore
        ]);

        (View.findDrawableById("VOID") as WatchUi.Text).setText("$ v o i d");
        (View.findDrawableById("TIME") as WatchUi.Text).setText(timeString);
        (View.findDrawableById("DATE") as WatchUi.Text).setText(dateString);
        (View.findDrawableById("BATTERY") as WatchUi.Text).setText(batteryString);
        (View.findDrawableById("DISTANCE") as WatchUi.Text).setText(distString);
        (View.findDrawableById("BODY_BATTERY") as WatchUi.Text).setText(bbString);
        (View.findDrawableById("SLEEP_SCORE") as WatchUi.Text).setText(sleepString);
        
        View.onUpdate(dc);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

}
