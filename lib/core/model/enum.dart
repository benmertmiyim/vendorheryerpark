enum PermissionEnum{
  owner,
  employee,
}

String permissionToString(PermissionEnum permission) {
  switch (permission) {
    case PermissionEnum.employee:
      return "Employee";
    case PermissionEnum.owner:
      return "Owner";
    default:
      return "Undefined";
  }
}

PermissionEnum permissionFromString(String permission) {
  switch (permission) {
    case "employee":
      return PermissionEnum.employee;
    case "owner":
      return PermissionEnum.owner;
    default:
      return PermissionEnum.employee;
  }
}

enum StatusEnum{
  process,
  approval,
  denied,
  payment,
  completed,
  cancelled,
}

String statusToString(StatusEnum status) {
  switch (status) {
    case StatusEnum.process:
      return "Process";
    case StatusEnum.approval:
      return "Approval";
    case StatusEnum.denied:
      return "Denied";
    case StatusEnum.payment:
      return "Payment";
    case StatusEnum.completed:
      return "Completed";
    case StatusEnum.cancelled:
      return "Cancelled";
    default:
      return "Undefined";
  }
}

StatusEnum statusFromString(String status) {
  switch (status) {
    case "process":
      return StatusEnum.process;
    case "approval":
      return StatusEnum.approval;
    case "denied":
      return StatusEnum.denied;
    case "cancelled":
      return StatusEnum.cancelled;
    case "payment":
      return StatusEnum.payment;
    case "completed":
      return StatusEnum.completed;
    default:
      return StatusEnum.process;
  }
}