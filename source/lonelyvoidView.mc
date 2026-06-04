import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Complications;
import Toybox.Time;
import Toybox.ActivityMonitor;

class lonelyvoidView extends WatchUi.WatchFace {
    private var _bodyBatteryId as Toybox.Complications.Id or Null;
    private var _bodyBatteryStr as String = "[ BB: -- ]";

    private var _tempId as Toybox.Complications.Id or Null;
    private var _rawTemp as Number or Null = null;

    private var _voidLabel as WatchUi.Text or Null;
    private var _timeLabel as WatchUi.Text or Null;
    private var _dateLabel as WatchUi.Text or Null;
    private var _batteryLabel as WatchUi.Text or Null;
    private var _distanceLabel as WatchUi.Text or Null;
    private var _bodyBatteryLabel as WatchUi.Text or Null;
    private var _weatherLabel as WatchUi.Text or Null;

    function initialize() {
        WatchFace.initialize();

        if (Toybox has :Complications) {
            Complications.registerComplicationChangeCallback(method(:onComplicationChanged));
            
            _bodyBatteryId = new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY);
            if (_bodyBatteryId != null) { Complications.subscribeToUpdates(_bodyBatteryId); }

            _tempId = new Complications.Id(Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE);
            if (_tempId != null) { Complications.subscribeToUpdates(_tempId); }
        }
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        _voidLabel = View.findDrawableById("VOID") as WatchUi.Text or Null;
        _timeLabel = View.findDrawableById("TIME") as WatchUi.Text or Null;
        _dateLabel = View.findDrawableById("DATE") as WatchUi.Text or Null;
        _batteryLabel = View.findDrawableById("BATTERY") as WatchUi.Text or Null;
        _distanceLabel = View.findDrawableById("DISTANCE") as WatchUi.Text or Null;
        _bodyBatteryLabel = View.findDrawableById("BODY_BATTERY") as WatchUi.Text or Null;
        _weatherLabel = View.findDrawableById("WEATHER") as WatchUi.Text or Null;
    }

    function onShow() as Void {
    }

    function onComplicationChanged(id as Toybox.Complications.Id) as Void {
        if (Toybox has :Complications) {
            if (_bodyBatteryId != null && id.equals(_bodyBatteryId)) {
                var complication = Complications.getComplication(id);
                if (complication != null && complication.value != null) {
                    _bodyBatteryStr = Lang.format("[ BB: $1$ ]", [complication.value]);
                }
            }

            if (_tempId != null && id.equals(_tempId)) {
                var complication = Complications.getComplication(id);
                if (complication != null && complication.value != null) {
                    _rawTemp = complication.value.toNumber();
                }
            }

            WatchUi.requestUpdate();
        }
    }

    function onUpdate(dc as Graphics.Dc) as Void {
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

        var batteryString = Lang.format("[ $1$% ]", [battery]);

        if (actInfo != null && actInfo.distance != null) {
            distance = actInfo.distance / 100000.0;
        }

        var distString = Lang.format("[ $1$km ]", [
            distance.format("%.2f")
        ]);

        if (_voidLabel != null) { _voidLabel.setText("$ v o i d _"); }
        if (_timeLabel != null) { _timeLabel.setText(timeString); }
        if (_dateLabel != null) { _dateLabel.setText(dateString); }
        if (_batteryLabel != null) { _batteryLabel.setText(batteryString); }
        if (_distanceLabel != null) { _distanceLabel.setText(distString); }
        if (_bodyBatteryLabel != null) { _bodyBatteryLabel.setText(_bodyBatteryStr); }

        if (_weatherLabel != null) {
            var tempValue = (_rawTemp != null) ? _rawTemp.format("%d") + "°" : "--°";
            var tempStr = Lang.format("[ $1$ ]", [tempValue]);
            _weatherLabel.setText(tempStr);
        }

        View.onUpdate(dc);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}