class APIpath{
  static String task(String uid,String taskId)=>'/users/$uid/tasks/$taskId';
  static String tasks(String uid)=>'/users/$uid/tasks';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid)=>'/users/$uid/entries';
  static String thought(String uid,String tid)=>'users/$uid/thought/$tid';
}