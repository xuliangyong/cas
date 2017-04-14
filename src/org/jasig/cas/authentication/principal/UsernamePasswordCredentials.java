/*
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License.  You may obtain a
 * copy of the License at the following location:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.jasig.cas.authentication.principal;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * UsernamePasswordCredentials respresents the username and password that a user
 * may provide in order to prove the authenticity of who they say they are.
 * 
 * @author Scott Battaglia
 * @version $Revision: 1.2 $ $Date: 2007/01/22 20:35:26 $
 * @since 3.0
 *        <p>
 *        This is a published and supported CAS Server 3 API.
 *        </p>
 */
public class UsernamePasswordCredentials implements Credentials {

	/** Unique ID for serialization. */
	private static final long serialVersionUID = -8343864967200862794L;

	/** The username. */
	/*@NotNull
	@Size(min = 1, message = "required.username")*/
	private String username;

	/** The password. */
	/*@NotNull
	@Size(min = 1, message = "required.password")*/
	private String password;

	private String verificationCode;//验证码

    private Integer error_count;//错误次数；
    
    private String old_loginIp;//上次的登录的ip
    
    private String loginIp;//新增加的IP
    
    private Integer red_flag; //红边框标记

	/**
	 * @return Returns the password.
	 */
	public final String getPassword() {
		return this.password;
	}

	/**
	 * @param password
	 *            The password to set.
	 */
	public final void setPassword(final String password) {
		this.password = password;
	}

	/**
	 * @return Returns the userName.
	 */
	public final String getUsername() {
		return this.username;
	}

	/**
	 * @param userName
	 *            The userName to set.
	 */
	public final void setUsername(final String userName) {
		this.username = userName;
	}
	
	public String getVerificationCode() {
		return verificationCode;
	}

	public void setVerificationCode(String verificationCode) {
		this.verificationCode = verificationCode;
	}
	

	public String getOld_loginIp() {
		return old_loginIp;
	}

	public void setOld_loginIp(String old_loginIp) {
		this.old_loginIp = old_loginIp;
	}

	public String getLoginIp() {
		return loginIp;
	}

	public void setLoginIp(String loginIp) {
		this.loginIp = loginIp;
	}

	public Integer getError_count() {
		return error_count;
	}

	public void setError_count(Integer error_count) {
		this.error_count = error_count;
	}
	
	public Integer getRed_flag() {
		return red_flag;
	}

	public void setRed_flag(Integer red_flag) {
		this.red_flag = red_flag;
	}

	public String toString() {
		return "[username: " + this.username + "]";
	}

	@Override
	public boolean equals(final Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		UsernamePasswordCredentials that = (UsernamePasswordCredentials) o;

		if (password != null ? !password.equals(that.password) : that.password != null)
			return false;
		if (username != null ? !username.equals(that.username) : that.username != null)
			return false;
		if (verificationCode != null ? !verificationCode.equals(that.verificationCode) : that.verificationCode != null)
			return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = username != null ? username.hashCode() : 0;
		result = 31 * result + (password != null ? password.hashCode() : 0);
		return result;
	}
}
