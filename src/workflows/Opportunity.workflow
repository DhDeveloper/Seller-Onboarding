<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_invitation_details_to_SMS_system</fullName>
        <ccEmails>murali.dharnala@in.pwc.com</ccEmails>
        <description>Send invitation details to SMS system</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Invitation_to_SMS</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Stage_to_Registered</fullName>
        <field>StageName</field>
        <literalValue>Registered</literalValue>
        <name>Change Stage to Registered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeToOnboarding</fullName>
        <field>RecordTypeId</field>
        <lookupValue>InOnboarding</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateRecordTypeToOnboarding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AlertOnScreeningFailure</fullName>
        <actions>
            <name>Screening_Failed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SS_Screening__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change opportunity stage as %22Registered%22%2C if %22RedirectState%22 is 5</fullName>
        <actions>
            <name>Change_Stage_to_Registered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Redirect_State__c</field>
            <operation>equals</operation>
            <value>5</value>
        </criteriaItems>
        <description>Change opportunity stage as &quot;Registered&quot;, if &quot;RedirectState&quot; is 5 -  CSV Upload Processing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChangeRecordTypeWhenStageChanges</fullName>
        <actions>
            <name>UpdateRecordTypeToOnboarding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change record type of Opportunity to InOnboarding when stage changes appropriately</description>
        <formula>NOT(ISPICKVAL(StageName, &apos;Candidate For Onboarding&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Invitation To SMS</fullName>
        <actions>
            <name>Send_invitation_details_to_SMS_system</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Is_Invited__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <description>Send Invitation To SMS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Screening_Failed</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity cannot be Invited now as it has failed SS checks.
FYI.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Screening Failed</subject>
    </tasks>
</Workflow>
