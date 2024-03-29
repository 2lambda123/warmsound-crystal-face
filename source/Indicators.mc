using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;

import Toybox.Lang;

class Indicators extends Ui.Drawable {

	private var mSpacing;
	private var mBatteryWidth;

	private var mIndicator1Type;
	private var mIndicator2Type;
	private var mIndicator3Type;

	// private enum /* INDICATOR_TYPES */ {
	// 	INDICATOR_TYPE_BLUETOOTH,
	// 	INDICATOR_TYPE_ALARMS,
	// 	INDICATOR_TYPE_NOTIFICATIONS,
	// 	INDICATOR_TYPE_BLUETOOTH_OR_NOTIFICATIONS,
	// 	INDICATOR_TYPE_BATTERY
	// }

	typedef IndicatorsParams as {
		:locX as Number,
		:locY as Number,
		:spacingX as Number,
		:spacingY as Number,
		:batteryWidth as Number
	};

	function initialize(params as IndicatorsParams) {
		Drawable.initialize(params);

		if (params[:spacingX] != null) {
			mSpacing = params[:spacingX];
		} else {
			mSpacing = params[:spacingY];
		}
		mBatteryWidth = params[:batteryWidth];

		onSettingsChanged();
	}

	function onSettingsChanged() {
		mIndicator1Type = getPropertyValue("Indicator1Type");
		mIndicator2Type = getPropertyValue("Indicator2Type");
		mIndicator3Type = getPropertyValue("Indicator3Type");
	}

	function draw(dc) {

		// #123 Protect against null or unexpected type e.g. String.
		var indicatorCount = App.getApp().getIntProperty("IndicatorCount", 1);

		// // Horizontal layout for rectangle-148x205, rectangle-320x360
		// if (mIsHorizontal) {
		// 	drawHorizontal(dc, indicatorCount);

		// // Vertical layout for others.
		// } else {
		// 	drawVertical(dc, indicatorCount);
		// }
		drawIndicators(dc, indicatorCount);
	}

	(:horizontal_indicators)
	// function drawHorizontal(dc, indicatorCount) {
	function drawIndicators(dc, indicatorCount) {
		if (indicatorCount == 3) {
			drawIndicator(dc, mIndicator1Type, locX - mSpacing, locY);
			drawIndicator(dc, mIndicator2Type, locX, locY);
			drawIndicator(dc, mIndicator3Type, locX + mSpacing, locY);
		} else if (indicatorCount == 2) {
			drawIndicator(dc, mIndicator1Type, locX - (mSpacing / 2), locY);
			drawIndicator(dc, mIndicator2Type, locX + (mSpacing / 2), locY);
		} else if (indicatorCount == 1) {
			drawIndicator(dc, mIndicator1Type, locX, locY);
		}
	}

	(:vertical_indicators)
	// function drawVertical(dc, indicatorCount) {
	function drawIndicators(dc, indicatorCount) {
		if (indicatorCount == 3) {
			drawIndicator(dc, mIndicator1Type, locX, locY - mSpacing);
			drawIndicator(dc, mIndicator2Type, locX, locY);
			drawIndicator(dc, mIndicator3Type, locX, locY + mSpacing);
		} else if (indicatorCount == 2) {
			drawIndicator(dc, mIndicator1Type, locX, locY - (mSpacing / 2));
			drawIndicator(dc, mIndicator2Type, locX, locY + (mSpacing / 2));
		} else if (indicatorCount == 1) {
			drawIndicator(dc, mIndicator1Type, locX, locY);
		}
	}

	function drawIndicator(dc, indicatorType, x, y) {

		// Battery indicator.
		if (indicatorType == 4 /* INDICATOR_TYPE_BATTERY */) {
			drawBatteryMeter(dc, x, y, mBatteryWidth, mBatteryWidth / 2);
			return;
		}

		// Show notifications icon if connected and there are notifications, bluetoothicon otherwise.
		var settings = Sys.getDeviceSettings();
		if (indicatorType == 3 /* INDICATOR_TYPE_BLUETOOTH_OR_NOTIFICATIONS */) {
			if (settings.phoneConnected && (settings.notificationCount > 0)) {
				indicatorType = 2; // INDICATOR_TYPE_NOTIFICATIONS
			} else {
				indicatorType = 0; // INDICATOR_TYPE_BLUETOOTH
			}
		}

		// Get value for indicator type.
		var value = [
			/* INDICATOR_TYPE_BLUETOOTH */ settings.phoneConnected,
			/* INDICATOR_TYPE_ALARMS */ settings.alarmCount > 0,
			/* INDICATOR_TYPE_NOTIFICATIONS */ settings.notificationCount > 0
		][indicatorType];

		dc.setColor(value ? gThemeColour : gMeterBackgroundColour, Graphics.COLOR_TRANSPARENT);

		// Icon.
		dc.drawText(
			x,
			y,
			gIconsFont,
			["8", ":", "5"][indicatorType], // Get icon font char for indicator type.
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}
}
