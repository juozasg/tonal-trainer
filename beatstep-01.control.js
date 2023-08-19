loadAPI(18);

// Remove this if you want to be able to use deprecated methods without causing script to stop.
// This is useful during development.
host.setShouldFailOnDeprecatedUse(true);

host.defineController("juozasg", "beatstep-01", "0.1", "576550b6-369d-4dc2-aff3-202c404c3201", "juozasg");
host.defineMidiPorts(1, 1);

function init() {

   // TODO: Perform further initialization here.
   println("beatstep-01 initialized");
   
   cursorTrack = host.createCursorTrack(1, 1);
   cursorTrack.volume().markInterested();

   device = cursorTrack.createCursorDevice();

   remotes = device.createCursorRemoteControlsPage(8);
   for(var i = 0; i < 8; i++) {
      remotes.getParameter(i).markInterested();
   }
   // remotes.markInterested();

   host.getMidiInPort(0).setMidiCallback(onMidi);
   host.getMidiInPort(0).createNoteInput("beatstep-01");

   master = host.createMasterTrack(1);
}

function onMidi(status, data1, data2)
{
   // 178 = Chan 3 CC
   if(status == 178) {
      relative = data2 - 64;
      if(data1 == 7) {
         println(cursorTrack.volume().get())
         cursorTrack.volume().inc(relative * 1.2, 128);
      } else if(data1 >= 20 && data1 <= 27) {
         // cursorTrack.volume().reset();
         // println(data1 - 20);
         remote = remotes.getParameter(data1 - 20);
         println(remote.get() + " " + remote.getRaw())
         remote.inc(relative, 128);
      }
   }
   // printMidi(status, data1, data2);
   // println("status: " + status + " data1: " + data1 + " data2: " + data2);
}

function flush() {
   // TODO: Flush any output to your controller here.
}

function exit() {

}