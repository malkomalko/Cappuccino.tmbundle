# TextMate bundle for Cappuccino development

To install with Git:

    First make sure to remove any old Objective-J bundles then:

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    git clone git://github.com/malkomalko/Cappuccino.tmbundle.git
    osascript -e 'tell app "TextMate" to reload bundles'

## Features

* Snippets for:
  * Core
    * Snippets for generating classes/categories/importing/accessors/delegates/selectors
  * Appkit (more on the way)
    * (text) Label
    * (text) TextField
    * (text) Rounded TextField
  * Foundation (soon)
  * Resizing Masks
    * ![](http://img.skitch.com/20091111-ngysen5mbf3rf5b6hrgnx7rqdd.preview.png) (mf) Resize Full Width/Height
    * ![](http://img.skitch.com/20091111-k1t8n812m77g99acddb2cui6qb.preview.png) (mc) Fixed Center
    * ![](http://img.skitch.com/20091111-es8nfbj8uxkqkm2f2d5grd5dbj.preview.png) (mtl) Fixed Top Left
    * ![](http://img.skitch.com/20091111-tupmuncegxijma7eu2f27xqd8k.preview.png) (mtr) Fixed Top Right
    * ![](http://img.skitch.com/20091111-ne7u4rb9smgah7hxbd8ix2mw1e.preview.png) (mbr) Fixed Bottom Right
    * ![](http://img.skitch.com/20091111-bk811p7n8wfp81adnwnpdgm5pk.preview.png) (mbl) Fixed Bottom Left
    * ![](http://img.skitch.com/20091111-xm29km85mp2t442864h51ppqef.preview.png) (mhl) Resize Height Fixed Left
    * ![](http://img.skitch.com/20091111-7959c6us75g6ru44fm1ifywu8.preview.png) (mhr) Resize Height Fixed Right
    * ![](http://img.skitch.com/20091111-me47cnyw61ck7bj3dpqcxakstn.preview.png) (mwt) Resize Width Fixed Top
    * ![](http://img.skitch.com/20091111-njpxp63rn75f2gmdeyc9cj48qp.preview.png) (mwb) Resize Width Fixed Bottom
  * Utilities
    * (rect) CGRectGetWidth
    * (rect) CGRectGetHeight
    * (rect) CGRectMakeZero
    * (rect) CGRectMake
    * (color) common CPColor methods
* Language/Syntax
* Documentation for Word Command from rsim