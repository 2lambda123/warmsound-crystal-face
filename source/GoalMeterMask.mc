using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

import Toybox.Lang;

// Circular mask, filled with background colour, to hide goal meter rectangles.
class GoalMeterMask extends Ui.Drawable {

	private var mStroke;

	typedef GoalMeterMaskParams as {
		:stroke as Number
	};

	function initialize(params as GoalMeterMaskParams) {
		Drawable.initialize(params);

		mStroke = params[:stroke];
	}

	function draw(dc) {
		dc.setColor(gBackgroundColour, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(dc.getWidth() / 2, dc.getHeight() / 2, (dc.getWidth() / 2) - mStroke);
	}
}
