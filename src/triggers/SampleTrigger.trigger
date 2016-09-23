trigger SampleTrigger on Account (before insert) {
    Sample.SampleMethod();
}