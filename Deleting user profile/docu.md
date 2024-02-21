# WorkFlow:


Trigger:
The script can be triggered manually or automatically at a scheduled interval.

Initialization:
The script initializes by defining the number of days threshold, typically set to 14 days.

Threshold Calculation:
It calculates the threshold date by subtracting the threshold days from the current date.

User Profile Retrieval:
It retrieves a list of all user profiles on the system, excluding special profiles like "admin" and "default".

Profile Evaluation:
For each user profile, it checks the last use time. If the last use time is older than the threshold date, it adds the profile to the list of profiles to be deleted.

Deletion (What-If Mode):
If the script is in What-If mode, it outputs the list of profiles to be deleted without performing any actual deletions.

Deletion (Execution Mode):
If the script is not in What-If mode, it proceeds to delete each profile in the list of profiles to be deleted.
It attempts to delete each profile directory and outputs the result of each deletion attempt.
If a profile directory is successfully deleted, it outputs a success message. If not, it outputs an error message.

Completion:
Once all deletions are attempted, it outputs a summary message indicating the success or failure of the deletion process.

End:
The script execution ends.
