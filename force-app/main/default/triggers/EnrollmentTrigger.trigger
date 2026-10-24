trigger EnrollmentTrigger on Enrollment__c (
    before insert,
    before update
) {
    EnrollmentTriggerHandler.validateEnrollments(
        Trigger.new,
        Trigger.isUpdate ? Trigger.oldMap : null
    );
}