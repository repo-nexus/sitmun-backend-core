package org.sitmun.plugin.core.constraints;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.sitmun.plugin.core.test.TestConstants.SITMUN_ADMIN_USERNAME;
import static org.sitmun.plugin.core.test.TestUtils.withMockSitmunAdmin;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.sitmun.plugin.core.config.RepositoryRestConfig;
import org.sitmun.plugin.core.domain.Cartography;
import org.sitmun.plugin.core.domain.CartographyAvailability;
import org.sitmun.plugin.core.domain.Service;
import org.sitmun.plugin.core.domain.Territory;
import org.sitmun.plugin.core.repository.CartographyAvailabilityRepository;
import org.sitmun.plugin.core.repository.CartographyRepository;
import org.sitmun.plugin.core.repository.ServiceRepository;
import org.sitmun.plugin.core.repository.TerritoryRepository;
import org.sitmun.plugin.core.security.TokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.hateoas.MediaTypes;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public class CodeListTest {

  private static final String CARTOGRAPHY_NAME = "Cartography Name";
  private static final String CARTOGRAPHY_URI = "http://localhost/api/cartographies";
  @Autowired
  CartographyRepository cartographyRepository;
  @Autowired
  CartographyAvailabilityRepository cartographyAvailabilityRepository;
  @Autowired
  TokenProvider tokenProvider;
  @Autowired
  TerritoryRepository territoryRepository;
  @Autowired
  private ServiceRepository serviceRepository;
  @Autowired
  private MockMvc mvc;

  private List<Cartography> cartographies;
  private Service service;
  private Territory territory;
  private CartographyAvailability cartographyAvailability;

  @Before
  @WithMockUser(username = SITMUN_ADMIN_USERNAME)
  public void init() {
    territory = Territory.builder()
        .setName("Some territory")
        .setCode("")
        .setBlocked(false)
        .build();
    territoryRepository.save(territory);

    service = new Service();
    service.setName("Service");
    service.setServiceURL("");
    service.setType("");
    serviceRepository.save(service);

    cartographies = new ArrayList<>();

    Cartography cartography = Cartography.builder()
        .setName(CARTOGRAPHY_NAME)
        .setLayers(Collections.emptyList())
        .setApplyFilterToGetMap(false)
        .setApplyFilterToGetFeatureInfo(false)
        .setApplyFilterToSpatialSelection(false)
        .setService(service)
        .setAvailabilities(Collections.emptySet())
        .build();
    cartographies.add(cartography);

    Cartography cartographyWithAvailabilities = Cartography.builder()
        .setName("Cartography with availabilities")
        .setLayers(Collections.emptyList())
        .setApplyFilterToGetMap(false)
        .setApplyFilterToGetFeatureInfo(false)
        .setApplyFilterToSpatialSelection(false)
        .setService(service)
        .setAvailabilities(Collections.emptySet())
        .build();

    cartographies.add(cartographyWithAvailabilities);

    cartographyRepository.saveAll(cartographies);

    cartographyAvailability = new CartographyAvailability();
    cartographyAvailability.setCartography(cartographyWithAvailabilities);
    cartographyAvailability.setTerritory(territory);
    cartographyAvailability.setCreatedDate(new Date());

    cartographyAvailabilityRepository.save(cartographyAvailability);
  }

  @After
  public void cleanup() {
    withMockSitmunAdmin(() -> {
      cartographyAvailabilityRepository.delete(cartographyAvailability);
      cartographyRepository.deleteAll(cartographies);
      serviceRepository.delete(service);
      territoryRepository.delete(territory);
    });
  }

  @Test
  @WithMockUser(username = SITMUN_ADMIN_USERNAME)
  public void passIfCodeListValueIsValid() throws Exception {

    String content = new JSONObject()
        .put("name", CARTOGRAPHY_NAME)
        .put("layers", new JSONArray())
        .put("applyFilterToGetMap", false)
        .put("applyFilterToSpatialSelection", false)
        .put("applyFilterToGetFeatureInfo", false)
        .put("legendType", "LINK")
        .put("service", "http://localhost/api/services/" + service.getId())
        .toString();

    String location = mvc.perform(post(CARTOGRAPHY_URI)
        .contentType(MediaType.APPLICATION_JSON)
        .content(content)
    ).andExpect(status().isCreated())
        .andReturn().getResponse().getHeader("Location");

    assertThat(location, notNullValue());

    mvc.perform(get(location))
        .andExpect(status().isOk())
        .andExpect(content().contentType(MediaTypes.HAL_JSON))
        .andExpect(jsonPath("$.name", equalTo(CARTOGRAPHY_NAME)));
  }

  @Test
  @WithMockUser(username = SITMUN_ADMIN_USERNAME)
  public void failIfCodeListValueIsWrong() throws Exception {

    String content = new JSONObject()
        .put("name", CARTOGRAPHY_NAME)
        .put("layers", new JSONArray())
        .put("applyFilterToGetMap", false)
        .put("applyFilterToSpatialSelection", false)
        .put("applyFilterToGetFeatureInfo", false)
        .put("legendType", "WRONG VALUE")
        .put("service", "http://localhost/api/services/" + service.getId())
        .toString();

    mvc.perform(post(CARTOGRAPHY_URI)
        .contentType(MediaType.APPLICATION_JSON)
        .content(content)
    ).andExpect(status().is4xxClientError())
        .andExpect(jsonPath("$.errors[0].property", equalTo("legendType")))
        .andExpect(jsonPath("$.errors[0].invalidValue", equalTo("WRONG VALUE")));
  }

  @TestConfiguration
  static class ContextConfiguration {
    @Bean
    public Validator validator() {
      return new LocalValidatorFactoryBean();
    }

    @Bean
    RepositoryRestConfigurer repositoryRestConfigurer() {
      return new RepositoryRestConfig(validator());
    }
  }
}
