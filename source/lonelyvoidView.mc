import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class lonelyvoidView extends WatchUi.WatchFace {
    private var _bodyBatteryId as Toybox.Complications.Id or Null;
    private var _bodyBatteryStr as String = "[ BB: -- ]";
    private var _weatherId as Toybox.Complications.Id or Null;
    private var _weatherStr as String = "[ -- ]";

    function initialize() {
        Complications.registerComplicationChangeCallback(method(:onComplicationChanged));
        
        _bodyBatteryId = new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY);
        Complications.subscribeToUpdates(_bodyBatteryId);
        _weatherId = new Complications.Id(Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE);
        Complications.subscribeToUpdates(_weatherId);

        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {
    }

    function onComplicationChanged(id as Toybox.Complications.Id) as Void {
        if (_bodyBatteryId != null && id.equals(_bodyBatteryId)) {
            var complication = Complications.getComplication(id);
            if (complication != null && complication.value != null) {
                _bodyBatteryStr = Lang.format("[ BB: $1$ ]", [complication.value]);
            }
        }

        if (_weatherId != null && id.equals(_weatherId)) {
            var complication = Complications.getComplication(id);
            if (complication != null && complication.value != null) {
                _weatherStr = Lang.format("[ $1$° ]", [complication.value.format("%d")]);
            }
        }

        WatchUi.requestUpdate();
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

        (View.findDrawableById("VOID") as WatchUi.Text).setText("$ v o i d");
        (View.findDrawableById("TIME") as WatchUi.Text).setText(timeString);
        (View.findDrawableById("DATE") as WatchUi.Text).setText(dateString);
        (View.findDrawableById("BATTERY") as WatchUi.Text).setText(batteryString);
        (View.findDrawableById("DISTANCE") as WatchUi.Text).setText(distString);
        (View.findDrawableById("BODY_BATTERY") as WatchUi.Text or Null).setText(_bodyBatteryStr);
        (View.findDrawableById("WEATHER_TEMP") as WatchUi.Text or Null).setText(_weatherStr);

        View.onUpdate(dc);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}