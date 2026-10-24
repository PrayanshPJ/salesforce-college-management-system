public class EnrollmentTriggerHandler {

    public static void validateEnrollments(
        List<Enrollment__c> newEnrollments,
        Map<Id, Enrollment__c> oldMap
    ) {
        Set<Id> studentIds = new Set<Id>();
        Set<Id> subjectIds = new Set<Id>();

        for (Enrollment__c e : newEnrollments) {
            if (e.Student__c != null) {
                studentIds.add(e.Student__c);
            }
            if (e.Subject__c != null) {
                subjectIds.add(e.Subject__c);
            }
        }

        Map<Id, Student__c> students = new Map<Id, Student__c>([
            SELECT Id, Status__c
            FROM Student__c
            WHERE Id IN :studentIds
        ]);

        Map<Id, Subject__c> subjects = new Map<Id, Subject__c>([
            SELECT Id, Status__c
            FROM Subject__c
            WHERE Id IN :subjectIds
        ]);

        Set<String> combinationsInBatch = new Set<String>();
        Set<Id> currentRecordIds = new Set<Id>();

        if (oldMap != null) {
            currentRecordIds.addAll(oldMap.keySet());
        }

        for (Enrollment__c e : newEnrollments) {
            if (e.Student__c == null || e.Subject__c == null) {
                continue;
            }

            Student__c student = students.get(e.Student__c);
            Subject__c subject = subjects.get(e.Subject__c);

            if (student != null && student.Status__c != 'Active') {
    Boolean isNewEnrollment = e.Id == null;
    Boolean studentChanged =
        oldMap != null &&
        oldMap.containsKey(e.Id) &&
        oldMap.get(e.Id).Student__c != e.Student__c;

    if (isNewEnrollment || studentChanged) {
        e.addError(
            'Only Active students can be enrolled.'
        );
    }
}

            if (subject != null && subject.Status__c != 'Active') {
    Boolean isNewEnrollment = e.Id == null;
    Boolean subjectChanged =
        oldMap != null &&
        oldMap.containsKey(e.Id) &&
        oldMap.get(e.Id).Subject__c != e.Subject__c;

    if (isNewEnrollment || subjectChanged) {
        e.addError(
            'Only Active subjects can be selected.'
        );
    }
}

            String key = String.valueOf(e.Student__c)
                + '-' + String.valueOf(e.Subject__c);

            if (combinationsInBatch.contains(key)) {
                e.addError(
                    'This student is already enrolled in this subject.'
                );
            } else {
                combinationsInBatch.add(key);
            }
        }

        for (Enrollment__c existing : [
            SELECT Id, Student__c, Subject__c
            FROM Enrollment__c
            WHERE Student__c IN :studentIds
            AND Subject__c IN :subjectIds
        ]) {
            if (currentRecordIds.contains(existing.Id)) {
                continue;
            }

            String existingKey = String.valueOf(existing.Student__c)
                + '-' + String.valueOf(existing.Subject__c);

            for (Enrollment__c e : newEnrollments) {
                if (e.Student__c == existing.Student__c
                    && e.Subject__c == existing.Subject__c) {
                    e.addError(
                        'This student is already enrolled in this subject.'
                    );
                }
            }
        }
    }
}