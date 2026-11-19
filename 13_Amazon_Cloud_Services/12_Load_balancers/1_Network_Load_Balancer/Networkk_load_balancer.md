





### Work flow

		Browser
			↓
		Internet
			↓
		NLB DNS Name
			↓
		NLB Listener (TCP 80)
			↓
		Target Group
			↓
		One Healthy EC2 (Nginx)
			↓
		Response back to User
