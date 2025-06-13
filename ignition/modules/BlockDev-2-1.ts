// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import {buildModule} from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("BlockDev21Module", (m) => {

    // const courseBadge = m.contract("CourseBadge", [], {});
    // const studentID = m.contract("StudentID", [], {});
    const campusCredit = m.contract("CampusCredit", [], {});

    return {
        // courseBadge,
        // studentID,
        campusCredit
    };
});

