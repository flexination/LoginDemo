package actionscripts
{
    import flash.display.Sprite;
    import flash.events.*;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;

    public class NoSoupSound extends Sprite {
        private var url:String = "../sounds/nosoup.mp3";
        private var song:SoundChannel;

        public function getSound():void {
            var request:URLRequest = new URLRequest(url);
            var soundFactory:Sound = new Sound();
            soundFactory.addEventListener(Event.COMPLETE, completeHandler);
            soundFactory.addEventListener(Event.ID3, id3Handler);
            soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            soundFactory.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            soundFactory.load(request);
            song = soundFactory.play();
        }

        private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
        }

        private function id3Handler(event:Event):void {
            trace("id3Handler: " + event);
        }

        private function ioErrorHandler(event:Event):void {
            trace("ioErrorHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: " + event);
        }
    }
}