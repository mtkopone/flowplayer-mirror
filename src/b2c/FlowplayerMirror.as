package b2c {

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.media.Video;
import org.flowplayer.model.Plugin;
import org.flowplayer.model.PluginModel;
import org.flowplayer.view.Flowplayer;

public class FlowplayerMirror extends Sprite implements Plugin {
  private var videos:Array = [];
  private var _model:PluginModel;

  public function FlowplayerMirror() {}

  public function onConfig(model:PluginModel):void {
    _model = model;
  }

  public function getDefaultConfig():Object {
    return null;
  }

  public function onLoad(player:Flowplayer):void {
    player.screen.getDisplayObject().addEventListener(Event.ADDED, onAdd);
    player.playlist.onResized(onResize);
    _model.dispatchOnLoad();
  }

  private function onResize(event: Event):void {
    for (var ii:String in videos) {
      ensureFlipped(videos[ii]);
    }
  }

  private function onAdd(event:Event):void {
    if (event.target instanceof Video) {
      var video:Video = event.target as Video;
      ensureFlipped(video);
      if (videos.indexOf(video) == -1) {
        videos.push(video);
      }
    }
  }

  private function ensureFlipped(video:Video):void {
    var matrix: Matrix = video.transform.matrix;
    matrix.a = -Math.abs(matrix.a);
    matrix.d = Math.abs(matrix.d);
    matrix.tx = video.width;
    video.transform.matrix = matrix;
  }

  /*
  public function debugVideo(s: String, video: Video):void {
    trace(s + '> (' + video.width + ', ' + video.height + ') (' + video.x + ', ' + video.y + ') ' + video.transform.matrix);
  }
  */

}
}
