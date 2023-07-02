const selectAction = document.getElementById("select-action");
const inputFields = document.getElementById("input-fields");
const confirmButton = document.getElementById("confirm");

selectAction.addEventListener("change", () => {
  const switch_id = document.getElementById("switch-select").value;
  const selectedOption = selectAction.value;
  if (selectedOption === "add-rule" || selectedOption === "block-traffic") {
    inputFields.innerHTML = `
      <label for="source-ip">Source IP:</label>
      <input type="text" id="source-ip" name="source-ip" placeholder="example: 10.0.0.1"><br>
      <label for="destination-ip">Destination IP:</label>
      <input type="text" id="destination-ip" name="destination-ip"  placeholder="example: 10.0.0.2"><br>
      <label for="pirority">pirority:</label>
      <input type="text" id="pirority" name="pirorityp" placeholder="example: 11"><br>
      <label for="protocol">Protocol:</label>
      <select id="protocol" name="protocol">
      <option value="TCP">TCP</option>
      <option value="UDP">UDP</option>
      <option value="ICMP">ICMP</option>
      <option value="ICMPv6">ICMPv6</option>
      <option value="IPV6">IPV6</option>
    </select>
    `;
  } else if (selectedOption == "delete-rule") {
    inputFields.innerHTML = `
            <label for="rule-id">Rule ID:</label>
            <input type="text" id="rule-id" name="rule-id">
            <br>
          `;
  } else {
    inputFields.innerHTML = "";
  }
});

confirmButton.addEventListener("click", () => {
  const selectedOption = selectAction.value;
  const switch_id = document.getElementById("switch-select").value;
  let api_url;
  if (selectedOption === "get-status") {
    api_url = "http://192.168.38.130:8080/firewall/module/status";
    fetch(
      `https://192.168.38.130:5000/send?api_url=${api_url}&action=get_status`
    )
      .then((response) => response.json())
      .then((data) => showAlert(data));
  } else if (selectedOption === "enable-firewall") {
    api_url = `http://192.168.38.130:8080/firewall/module/enable/000000000000000${switch_id}`;
    fetch(
      `https://192.168.38.130:5000/send?api_url=${api_url}&action=enable_firewall`,
      { method: "PUT" }
    )
      .then((response) => response.json())
      .then((data) => showAlert(data));
  } else if (selectedOption === "get-rules") {
    api_url = `http://192.168.38.130:8080/firewall/rules/000000000000000${switch_id}`;
    fetch(`https://192.168.38.130:5000/send?api_url=${api_url}&action=get_rules`)
      .then((response) => response.json())
      .then((data) => showAlert(data));
  } else if (selectedOption === "add-rule") {
    const sourceIp = document.getElementById("source-ip").value;
    const destinationIp = document.getElementById("destination-ip").value;
    const protocol = document.getElementById("protocol").value;
    const pirority = document.getElementById("pirority").value;
    api_url = `http://192.168.38.130:8080/firewall/rules/000000000000000${switch_id}`;
    fetch(
      `https://192.168.38.130:5000/send?api_url=${api_url}&action=add_rule`,
      {
        method: "POST",
        body: JSON.stringify({
          nw_src: sourceIp,
          nw_dst: destinationIp,
          nw_proto: protocol,
          pirority: pirority,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((data) => showAlert(data));
  } else if (selectedOption === "block-traffic") {
    const sourceIp = document.getElementById("source-ip").value;
    const destinationIp = document.getElementById("destination-ip").value;
    const protocol = document.getElementById("protocol").value;
    const pirority = document.getElementById("pirority").value;
    api_url = `http://192.168.38.130:8080/firewall/rules/000000000000000${switch_id}`;
    fetch(
      `https://192.168.38.130:5000/send?api_url=${api_url}&action=block_traffic`,
      {
        method: "POST",
        body: JSON.stringify({
          nw_src: sourceIp,
          nw_dst: destinationIp,
          nw_proto: protocol,
          actions: "DENY",
          pirority: pirority,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((data) => showAlert(data));
  } else if (selectedOption === "delete-rule") {
    const ruleId = document.getElementById("rule-id").value;

    api_url = `http://192.168.38.130:8080/firewall/rules/000000000000000${switch_id}`;
    fetch(
      `https://192.168.38.130:5000/send?api_url=${api_url}&action=delete_rule`,
      {
        method: "DELETE",
        body: JSON.stringify({ rule_id: ruleId }),
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((data) => showAlert(data));
  }
});

