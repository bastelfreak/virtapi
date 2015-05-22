## Update a vm state
----
  Update one or both attributes of a vm state. the state is referenced via his id or name. Return content is the state id.

* **URL**

  /vm_states/:id
  /vm_states/:name

* **Method:**
  
  `UPDATE`
  
* **URL Params**

   **Required:**
 
    None

   **Optional:**
 
    None

* **Data Params**

  **Required:**

    `name=[string]` and/or `description=[string]`

  **Optional:**

    None

* **Success Response:**
  

  * **Code:** 200
    **Content:** `{ id : 42 }`
 
* **Error Response:**


  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "Log in" }`

  OR

  * **Code:** 422 UNPROCESSABLE ENTRY <br />
    **Content:** `{ error : "Email Invalid" }`

* **Sample Call:**


* **Notes:**
Each VM can only have one current state. We do not track the state history of a VM, several VMs can have the same state.
